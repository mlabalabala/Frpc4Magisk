#!/system/bin/sh

scripts_dir="${0%/*}"
. ${scripts_dir}/conf.sh

start_service() {
  if [ ! -f "${moddir}/disable" ]; then
    "${scripts_dir}/service.sh" start
  else
    "${scripts_dir}/service.sh" stop
  fi
}

if [ -f "${data_dir}/frpc.toml" ]; then
  ${scripts_dir}/service.sh verify
  if [ "$?" -eq 0 ]; then
    start_service
  else
    log "config file is not ok."
    return 9
  fi
fi
start_inotifyd