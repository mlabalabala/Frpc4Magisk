#!/system/bin/sh

(
    until [ $(getprop init.svc.bootanim) = "stopped" ]; do
        sleep 10
    done

    if [ -f "/data/adb/frpc/start.sh" ]; then
        chmod 755 /data/adb/frpc/start.sh
        /data/adb/frpc/start.sh
    else
        echo "File '/data/adb/frpc/start.sh' not found"
    fi
)&