#!/system/bin/sh

scripts_dir="${0%/*}"
. ${scripts_dir}/conf.sh

events="$1"
monitor_dir="$2"
monitor_file="$3"

service_control() {
  if [ "${monitor_file}" = "disable" ]; then
    if [ "${events}" = "d" ]; then
      ${scripts_dir}/service.sh start > "${data_dir}/run.log" 2>&1
    elif [ "${events}" = "n" ]; then
      ${scripts_dir}/service.sh stop >> "${data_dir}/run.log" 2>&1
    fi
  fi
}


mkdir -p "${data_dir}"
service_control