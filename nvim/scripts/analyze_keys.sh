#!/usr/bin/env bash
# Neovim キー操作ログ解析
# Usage: analyze_keys.sh [DAYS] [full|summary]
#   DAYS    : 集計日数 (default: 7)
#   FORMAT  : full=詳細レポート / summary=1行サマリー (default: full)

set -euo pipefail

DAYS=${1:-7}
FORMAT=${2:-full}
LOG="${HOME}/.local/share/nvim/keylog.jsonl"

if [[ ! -f "$LOG" ]]; then
    echo "ログが見つかりません: $LOG" >&2
    exit 1
fi

CUTOFF=$(( ($(date +%s) - DAYS * 86400) * 1000 ))

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT
jq -c "select(.t >= $CUTOFF)" "$LOG" > "$TMP"

TOTAL=$(wc -l < "$TMP" | tr -d ' ')

if [[ "$TOTAL" -eq 0 ]]; then
    echo "直近 ${DAYS} 日間のデータがありません。nvim を使うとログが蓄積されます。"
    exit 0
fi

# ---- summary mode ----
if [[ "$FORMAT" == "summary" ]]; then
    ISSUE_COUNT=$(jq -r 'select(.m=="n") | .k' "$TMP" | awk '
        { run = ($0 == prev) ? run+1 : 1; prev=$0 }
        $0 ~ /^[hjkl]$/ && run == 4 { issues++ }
        END { print (issues+0) }
    ')
    printf '%s キー | 改善ポイント %s 件\n' "$TOTAL" "$ISSUE_COUNT"
    exit 0
fi

# ---- full report ----
FIRST_TS=$(jq -r '.t' "$TMP" | head -1)
LAST_TS=$(jq -r  '.t' "$TMP" | tail -1)
first_date=$(date -r $(( FIRST_TS / 1000 )) '+%Y-%m-%d %H:%M')
last_date=$(date -r  $(( LAST_TS  / 1000 )) '+%Y-%m-%d %H:%M')

echo "# Neovim キー操作 効率化レポート"
echo ""
echo "**集計期間:** 直近 ${DAYS} 日間 (${first_date} 〜 ${last_date})"
echo "**総キーストローク:** ${TOTAL} キー"
echo ""

echo "## モード別割合"
jq -r '.m' "$TMP" | sort | uniq -c | sort -rn | awk -v total="$TOTAL" '
BEGIN {
    modes["n"]="Normal"; modes["i"]="Insert"; modes["v"]="Visual"
    modes["V"]="Visual Line"; modes["c"]="Command"; modes["R"]="Replace"; modes["t"]="Terminal"
}
{ m=$2; name=(m in modes)?modes[m]:m; printf "- %s: %d (%.1f%%)\n", name, $1, $1*100/total }'

echo ""
echo "## Normal モード よく使うキー Top 20"
jq -r 'select(.m=="n") | .k' "$TMP" | sort | uniq -c | sort -rn | head -20 | \
    awk '{printf "- `%s`: %d\n", $2, $1}'

echo ""
echo "## Insert モード よく使うキー Top 10"
jq -r 'select(.m=="i") | .k' "$TMP" | sort | uniq -c | sort -rn | head -10 | \
    awk '{printf "- `%s`: %d\n", $2, $1}'

echo ""
echo "## よく使う 2連続キー (Normal, 600ms以内) Top 15"
jq -r 'select(.m=="n") | "\(.t)\t\(.k)"' "$TMP" | awk -F'\t' '
    NR > 1 && ($1 - prev_t) <= 600 { print prev_k "|||" $2 }
    { prev_t=$1; prev_k=$2 }
' | sort | uniq -c | sort -rn | head -15 | awk '{
    split($2, p, "|||"); printf "- `%s` `%s`: %d\n", p[1], p[2], $1 }'

echo ""
echo "## よく使う 3連続キー (Normal, 1000ms以内) Top 10"
jq -r 'select(.m=="n") | "\(.t)\t\(.k)"' "$TMP" | awk -F'\t' '
    { keys[NR]=$2; times[NR]=$1 }
    NR > 2 && (times[NR] - times[NR-2]) <= 1000 {
        print keys[NR-2] "|||" keys[NR-1] "|||" keys[NR]
    }
' | sort | uniq -c | sort -rn | head -10 | awk '{
    split($2, p, "|||"); printf "- `%s` `%s` `%s`: %d\n", p[1], p[2], p[3], $1 }'

echo ""
echo "## 非効率パターン検出"

ISSUES=()

# hjkl 4連打
HJKL=$(jq -r 'select(.m=="n") | .k' "$TMP" | awk '
{ run = ($0 == prev) ? run+1 : 1; prev=$0 }
$0 ~ /^[hjkl]$/ && run == 4 { incidents[$0]++ }
$0 ~ /^[hjkl]$/ && run >= 4 { waste[$0]++ }
END {
    labels["j"]="j (↓)"; labels["k"]="k (↑)"; labels["h"]="h (←)"; labels["l"]="l (→)"
    suggest["j"]="<count>j / } / <C-d> / / 検索"
    suggest["k"]="<count>k / { / <C-u>"
    suggest["h"]="b / B / F<char> / ^"
    suggest["l"]="w / e / f<char> / $"
    for (d in incidents)
        printf "- `%s` 4連打以上: %d回 (計%d キー節約可能) → %s\n",
            labels[d], incidents[d], waste[d], suggest[d]
}')
[[ -n "$HJKL" ]] && ISSUES+=("$HJKL")

# <Esc> → 即挿入モード
ESC_REENTER=$(jq -r 'select(.m=="n") | .k' "$TMP" | awk '
    NR > 1 && prev == "<Esc>" && $0 ~ /^[iaAIoOcs]$/ { n++ }
    { prev=$0 } END { print (n+0) }')
[[ "$ESC_REENTER" -gt 5 ]] && \
    ISSUES+=("- \`<Esc>\` → 即挿入モード復帰: ${ESC_REENTER}回 → \`c\`/\`s\` 系で1操作に圧縮できるか確認")

# :w 手動保存
SAVES=$(jq -r 'select(.m=="c") | "\(.t)\t\(.k)"' "$TMP" | awk -F'\t' '
    NR > 1 && $2 == "<CR>" && prev_k == "w" && ($1 - prev_t) < 2000 { n++ }
    { prev_t=$1; prev_k=$2 } END { print (n+0) }')
[[ "$SAVES" -gt 15 ]] && \
    ISSUES+=("- \`:w\` 手動保存: ${SAVES}回 → autosave の導入を検討")

if [[ ${#ISSUES[@]} -eq 0 ]]; then
    echo "- 検出なし"
else
    printf '%s\n' "${ISSUES[@]}"
fi
