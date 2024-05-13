#!/system/bin/sh

SKIPUNZIP=1
SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=false
LATESTARTSERVICE=true

DATADIR='/sdcard'

if [ $BOOTMODE ]; then
  ui_print "- 从 Magisk 应用程序安装!"
else
  abort "-----------------------------------------------------------"
  ui_print "! Please install in Magisk Manager"
  ui_print "! Install from recovery is NOT supported"
  abort "-----------------------------------------------------------"
fi

service_dir="/data/adb/service.d"
ui_print "- Magisk version: $MAGISK_VER ($MAGISK_VER_CODE)"

mkdir -p "${service_dir}"

if [ -d "/data/adb/modules/Frpc4Magisk" ]; then
  rm -rf "/data/adb/modules/Frpc4Magisk"
  ui_print "- Old module deleted."
fi

ui_print "- Installing Frpc for Magisk"
unzip -o "$ZIPFILE" -x 'META-INF/*' -d "$MODPATH" >&2

ui_print "- Create directories"
mkdir -p ${DATADIR}/frpc/

ui_print "- Move Frpc files"
cp -af ${MODPATH}/frpc/frpc.toml ${DATADIR}/frpc/

if [ -d "/data/adb/frpc" ]; then
  rm -rf /data/adb/frpc
  mv "$MODPATH/frpc" /data/adb/
  ui_print "- Old data replaced."
else
  mv "$MODPATH/frpc" /data/adb/
  ui_print "- New data created."
fi

ui_print "- Extract the files uninstall.sh and frpc_service.sh into the $MODPATH folder and ${service_dir}"
unzip -j -o "$ZIPFILE" 'uninstall.sh' -d "$MODPATH" >&2
unzip -j -o "$ZIPFILE" 'frpc_service.sh' -d "${service_dir}" >&2

ui_print "- Setting permissions"
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm_recursive /data/adb/frpc 0 3005 0755 0644
set_perm_recursive /data/adb/frpc/start.sh  0 3005 0755 0700
set_perm_recursive /data/adb/frpc/service.sh  0 3005 0755 0700
set_perm_recursive /data/adb/frpc/inotify.sh  0 3005 0755 0700
set_perm ${service_dir}/frpc_service.sh  0  0  0755
set_perm $MODPATH/uninstall.sh  0  0  0755
set_perm /data/adb/frpc/frpc  0  0  0755
set_perm /data/adb/frpc/start.sh  0  0  0755
set_perm /data/adb/frpc/service.sh  0  0  0755
set_perm /data/adb/frpc/inotify.sh  0  0  0755

ui_print "- Delete leftover files"
rm -rf $MODPATH/frpc
rm -f $MODPATH/frpc_service.sh

ui_print "- Installation is complete, reboot your device."
