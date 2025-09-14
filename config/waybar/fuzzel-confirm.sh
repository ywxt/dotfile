#!/bin/bash
# 用法: fuzzel-confirm.sh "<提示语>" "<Yes时执行的命令>" [超时秒数]
# 例子: ./fuzzel-confirm.sh "Shutdown?" "systemctl poweroff" 10

PROMPT="$1"
YES_CMD="$2"
TIMEOUT="${3:-30}"   # 默认30秒

# 在 prompt 中加入超时提示
FULL_PROMPT="$PROMPT (Yes after ${TIMEOUT}s)"

# 倒计时结束后默认执行 Yes
CHOICE=$(timeout "$TIMEOUT" \
    printf 'Yes\nNo' | fuzzel -d --lines 2 --prompt "$FULL_PROMPT")

# 超时或未选择则默认为 Yes
if [ -z "$CHOICE" ]; then
    CHOICE="Yes"
fi

case "$CHOICE" in
    "Yes")
        eval "$YES_CMD"
        ;;
    "No")
        exit 0
        ;;
    *)
        exit 1
        ;;
esac

