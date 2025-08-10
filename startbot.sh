#!/bin/bash


# Adjust exports as neccessary. This works on Ubuntu 24.04 server.
export TERM=xterm 
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH"

# Requires tmux
BOT_NAME="fortuneteller"                  # tmux session name
BOT_DIR="/REPLACE/WITH/FULL/PATH"
BOT_SCRIPT="bot.py"
VENV_DIR="$BOT_DIR/.venv"        # Adjust/rename if your venv is elsewhere
LOG_FILE="bot.log"

cd "$BOT_DIR" || exit 1

until ping -c1 google.com &>/dev/null; do
    echo "Waiting for network..."
    sleep 2
done

start_bot() {
    if [ ! -d "$VENV_DIR" ]; then
        echo "Virtual environment not found at $VENV_DIR"
        exit 1
    fi

    if tmux has-session -t "$BOT_NAME" 2>/dev/null; then
        echo "$BOT_NAME is already running in tmux session."
    else
        echo "Starting $BOT_NAME in tmux session..."
        > "$LOG_FILE"
        tmux new-session -d -s "$BOT_NAME" "source $VENV_DIR/bin/activate && python $BOT_SCRIPT >> $LOG_FILE 2>&1"
        echo "$BOT_NAME started in tmux session '$BOT_NAME'."

        echo "Waiting for invite link..."
        for i in {1..15}; do # Check for 30 seconds
            invite_link=$(grep "Invite link:" "$LOG_FILE" | tail -n 1 | sed 's/.*Invite link: //')
            if [ -n "$invite_link" ]; then
                echo "Invite link: $invite_link"
                return
            fi
            sleep 2
        done
        echo "Could not find invite link in the log file after 30 seconds."
    fi
}

stop_bot() {
    if tmux has-session -t "$BOT_NAME" 2>/dev/null; then
        echo "Stopping $BOT_NAME..."
        tmux kill-session -t "$BOT_NAME"
        echo "$BOT_NAME stopped."
    else
        echo "$BOT_NAME is not running."
    fi
}

status_bot() {
    if tmux has-session -t "$BOT_NAME" 2>/dev/null; then
        echo "$BOT_NAME is running in tmux session '$BOT_NAME'."
    else
        echo "$BOT_NAME is not running."
    fi
}

attach_bot() {
    if tmux has-session -t "$BOT_NAME" 2>/dev/null; then
        tmux attach -t "$BOT_NAME"
    else
        echo "$BOT_NAME is not running."
    fi
}

case "$1" in
    start|"")
        start_bot
        ;;
    stop)
        stop_bot
        ;;
    restart)
        stop_bot
        sleep 1
        start_bot
        ;;
    status)
        status_bot
        ;;
    attach)
        attach_bot
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|attach}"
        exit 1
        ;;
esac