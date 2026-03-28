#!/usr/bin/env bash
# detect-new-commands.sh
#
# $PATH のユーザー管理ディレクトリをスナップショット比較し、
# 新規追加されたコマンドを atuin で逆引きしてレポートを出力する。
#
# 使い方: bash detect-new-commands.sh
# sync 時に Claude Code がこのスクリプトを実行し、出力を元にマニフェストを更新する。

set -euo pipefail

SNAPSHOT_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-tracker"
SNAPSHOT_FILE="$SNAPSHOT_DIR/commands-snapshot.txt"
REPORT_FILE="$SNAPSHOT_DIR/new-commands-report.md"

mkdir -p "$SNAPSHOT_DIR"

# ユーザー管理のディレクトリのみ対象（システムパスは除外）
USER_DIRS=(
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    "$HOME/.bun/bin"
    "$HOME/.wasmtime/bin"
    "$HOME/.atuin/bin"
)

# uv tool の bin ディレクトリも動的に収集
if [ -d "$HOME/.local/share/uv/tools" ]; then
    for tool_dir in "$HOME/.local/share/uv/tools"/*/bin; do
        [ -d "$tool_dir" ] && USER_DIRS+=("$tool_dir")
    done
fi

# 現在の実行可能コマンド一覧を収集（basename のみ、ソート済み）
current_commands=$(
    for dir in "${USER_DIRS[@]}"; do
        [ -d "$dir" ] || continue
        find "$dir" -maxdepth 1 -type f -o -maxdepth 1 -type l 2>/dev/null | \
            xargs -I{} basename {}
    done | sort -u
)

# スナップショットがない場合は初回作成のみ
if [ ! -f "$SNAPSHOT_FILE" ]; then
    echo "$current_commands" > "$SNAPSHOT_FILE"
    echo "初回スナップショットを作成しました: $SNAPSHOT_FILE"
    echo "$(echo "$current_commands" | wc -l) コマンドを記録"
    exit 0
fi

# 差分計算（新規追加のみ）
new_commands=$(comm -13 "$SNAPSHOT_FILE" <(echo "$current_commands"))

if [ -z "$new_commands" ]; then
    echo "新規コマンドなし。スナップショットは最新です。"
    # スナップショットを更新
    echo "$current_commands" > "$SNAPSHOT_FILE"
    exit 0
fi

# レポート生成
{
    echo "## 新規コマンド検出レポート"
    echo "日時: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""
    echo "| コマンド | 推定インストールコマンド |"
    echo "|---|---|"

    while IFS= read -r cmd; do
        [ -z "$cmd" ] && continue

        # atuin で逆引き（インストール系コマンドで最後にマッチしたもの）
        install_cmd=$(
            atuin history list --format "{command}" 2>/dev/null \
            | grep -E "(cargo install|uv tool install|bun (install|add) -?-?g(lobal)?|mise (install|use)|pip install|npm install -g|snap install|apt install|curl.*(sh|install))" \
            | grep -F "$cmd" \
            | tail -1
        )

        if [ -z "$install_cmd" ]; then
            # マッチしなければ最後のインストール系コマンドだけ出す
            install_cmd=$(
                atuin history list --format "{command}" 2>/dev/null \
                | grep -E "^(cargo install|uv tool install|bun (install|add)|mise install)" \
                | tail -5
            )
            install_cmd="(不明 / 参考: ${install_cmd:-atuin に記録なし})"
        fi

        echo "| \`$cmd\` | \`$install_cmd\` |"
    done <<< "$new_commands"

    echo ""
    echo "## 対応が必要な可能性があるファイル"
    echo "- scripts/cargo-tools.txt"
    echo "- scripts/uv-tools.txt"
    echo "- scripts/bun-packages.txt"
} > "$REPORT_FILE"

# スナップショット更新
echo "$current_commands" > "$SNAPSHOT_FILE"

echo "レポートを生成しました: $REPORT_FILE"
echo "新規コマンド数: $(echo "$new_commands" | wc -l)"
echo ""
cat "$REPORT_FILE"
