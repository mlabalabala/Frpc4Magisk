#!/system/bin/sh

(
    until [ "$(getprop sys.boot_completed)" -eq 1 ]; do
        sleep 3
    done

    until [ -d "/sdcard/frpc" ]; do
      mkdir -p "/sdcard/frpc"
      sleep 3
    done

    if [ -f "/data/adb/frpc/start.sh" ]; then
        chmod 755 /data/adb/frpc/start.sh
        /data/adb/frpc/start.sh
    else
        echo "File '/data/adb/frpc/start.sh' not found"
    fi
)&