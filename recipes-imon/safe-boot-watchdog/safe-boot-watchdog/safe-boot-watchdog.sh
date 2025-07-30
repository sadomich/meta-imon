#!/bin/sh

WATCHDOG_DEV="/dev/watchdog"
INTERVAL=5
TIMEOUT=180
ELAPSED=0

echo "[safe-boot-watchdog] Start (timeout ${TIMEOUT}s)..."

while [ "$ELAPSED" -lt "$TIMEOUT" ]; do
    STATE=$(systemctl is-system-running 2>/dev/null | head -n1)
    [ -z "$STATE" ] && STATE="starting"

    WATCHDOG_ACTIVE=$(systemctl is-active watchdog.service 2>/dev/null | head -n1)
    [ -z "$WATCHDOG_ACTIVE" ] && WATCHDOG_ACTIVE="inactive"

    if [ "$STATE" = "running" ] || [ "$STATE" = "degraded" ]; then
        echo "[safe-boot-watchdog] systemd is $STATE – exiting"
        break
    elif [ "$WATCHDOG_ACTIVE" = "active" ]; then
        echo "[safe-boot-watchdog] watchdog.service is active – exiting"
        break
    else
        if [ -e "$WATCHDOG_DEV" ]; then
            echo > "$WATCHDOG_DEV"
            echo "[safe-boot-watchdog] Kicked watchdog (${ELAPSED}s, state: $STATE)"
        else
            echo "[safe-boot-watchdog] $WATCHDOG_DEV not found"
        fi

        sleep $INTERVAL
        ELAPSED=$((ELAPSED + INTERVAL))
    fi
done

echo "[safe-boot-watchdog] Done (state: $STATE, watchdog: $WATCHDOG_ACTIVE)"
exit 0

