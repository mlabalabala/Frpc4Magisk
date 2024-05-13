#!/system/bin/sh

frpc_mod_dir="/data/adb/frpc"
frpc_data_dir="/sdcard/frpc"
rm_data() {
  if [ ! -d "${frpc_mod_dir}" ]; then
    exit 1
  else
    rm -rf "${frpc_mod_dir}"
  fi

  if [ -d "${frpc_data_dir}" ]; then
    rm -rf "${frpc_data_dir}"
  fi

  if [ -f "/data/adb/service.d/frpc_service.sh" ]; then
    rm -rf "/data/adb/service.d/frpc_service.sh"
  fi

}

rm_data