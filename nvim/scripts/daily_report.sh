#!/usr/bin/env bash
# 毎日定時に呼ばれるレポートスクリプト
# crontab: 0 9 * * * $HOME/ghq/github.com/lCyou/my-dotconfig/nvim/scripts/daily_report.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT="${HOME}/.local/share/nvim/keylog_report.md"

"$SCRIPT_DIR/analyze_keys.sh" 1 full > "$REPORT" 2>&1

SUMMARY=$("$SCRIPT_DIR/analyze_keys.sh" 1 summary 2>/dev/null || echo "集計エラー")

osascript -e "display notification \"${SUMMARY}\" \
    with title \"Neovim 昨日の操作レポート\" \
    subtitle \"nvim で :KeyReport を実行すると詳細を確認できます\""
