#!/bin/bash
# 用法: fuzzel-confirm.sh "<提示语>" "<Yes时执行的命令>" [超时秒数]
# 例子: ./fuzzel-confirm.sh "Shutdown?" "systemctl poweroff" 10

PROMPT="$1"
YES_CMD="$2"
TIMEOUT="${3:-30}"   # 默认30秒

# 在 prompt 中加入超时提示
FULL_PROMPT="$PROMPT (Yes after ${TIMEOUT}s)"

# 倒计时结束后默认执行 Yes
CHOICE=$(printf "Yes\nNo\n" | timeout "$TIMEOUT" fuzzel -d --lines 2 --prompt "$FULL_PROMPT")
STATUS=$?   # 保存退出码

case $STATUS in
    0)  # 用户选择了选项
        if [ "$CHOICE" = "Yes" ]; then
            eval "$YES_CMD"
        fi
        ;;
    124) # 超时
        echo "超时，自动选择 Yes"
        eval "$YES_CMD"
        ;;
    *)  # 其他异常
        echo "未選擇，退出码=$STATUS"
        exit 1
        ;;
esac

