#!/bin/sh

# 获取当前脚本所在目录
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# config 文件夹路径
CONFIG_DIR="$SCRIPT_DIR/config"

# 目标软链接目录
TARGET_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

# 创建目标目录（如果不存在）
mkdir -p "$TARGET_DIR"

# 遍历 config 目录下的所有文件/文件夹
for ITEM in "$CONFIG_DIR"/*; do
    BASENAME=$(basename "$ITEM")

    if [ -d "$ITEM" ] && echo "$BASENAME" | grep -q '^gtk-'; then
        # 对 gtk-* 文件夹，只链接 settings.ini
	if [ ! -f "$TARGET_DIR/$BASENAME" ]; then
	    mkdir "$TARGET_DIR/$BASENAME"
	    echo "創建文件夾：$TARGET_DIR/$BASENAME"
	fi
        SETTINGS="$ITEM/settings.ini"
        if [ -f "$SETTINGS" ]; then
            ln -sf "$SETTINGS" "$TARGET_DIR/$BASENAME/settings.ini"
            echo "创建软链接: $TARGET_DIR/$BASENAME/settings.ini -> $SETTINGS"
        else
            echo "跳过: $BASENAME 中没有 settings.ini"
        fi
        continue
    fi

    # 创建软链接，如果已存在则覆盖
    ln -sf "$ITEM" "$TARGET_DIR/$BASENAME"
    echo "创建软链接: $TARGET_DIR/$BASENAME -> $ITEM"
done


