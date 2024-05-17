#!/system/bin/sh

bin_name="frpc"
moddir="/data/adb/modules/Frpc4Magisk"

if ! command -v busybox &> /dev/null; then
  export PATH="/data/adb/magisk:$PATH:/system/bin"
fi

# Take the current time
current_time=$(date +"%I:%M %P")
conf="/data/adb/${bin_name}/conf.sh"
busybox="/data/adb/magisk/busybox"
data_dir="/sdcard/${bin_name}"

log() {
  echo "$(date +"%Y-%m-%d %T") - $1" >> "${data_dir}/run.log"
}

# Get Process number
process() {
  local _bin="$1"
  local _get_process_pid
  _get_process_pid=$(ps | grep "${_bin}" | grep -v grep | awk '{print $1}' | xargs)
  if [ -n "${_get_process_pid}" ]; then
    echo "${_get_process_pid}"
  fi
}

# get running pid
get_running_pid() {
  local _bin="$1"
  local _pid=''
  local _get_exec_comm=''

  local _get_pid="$($busybox pidof "${_bin}")"
  if [ -n "${_get_pid}" ]; then
    local _get_pid_number="$(echo "${_get_pid}" | wc -w)"
    if [ -f "${scripts_dir}/${bin_name}.pid" ]; then
      _pid=$(cat ${scripts_dir}/${bin_name}.pid)
      if [ -n "${_pid}" ] && [ -d "/proc/${_pid}" ]; then
        _get_exec_comm="$(cat /proc/${_pid}/comm)"
        if [ "${_get_exec_comm}" == "${_bin}" ] && [ "${_get_pid_number}" -eq 1 ]; then
          echo "${_pid}"
          return
        fi
      fi
    fi
    echo "${_get_pid}"
    return
  fi

  local _process_get_pid="$(process ${_bin})"
  if [ -n "${_process_get_pid}" ]; then
    echo "${_process_get_pid}"
    return
  fi
}

check_run_status() {
  sleep 5
  local _get_pid="$($busybox pidof "${bin_name}")"
  if [ -z "${_get_pid}" ]; then
    if [ -e "${scripts_dir}/${bin_name}.pid" ]; then
      rm -f ${scripts_dir}/${bin_name}.pid
    fi
    touch ${moddir}/disable
    log "${bin_name} run feild! please check run.log."
    sed -Ei "s/^description=(\[.*][[:space:]]*)?/description=[ $current_time | ${bin_name} run feild! please check run.log! ] /g" "${moddir}/module.prop"
  else
    log "${bin_name} is running."
    sed -Ei "s/^description=(\[.*][[:space:]]*)?/description=[ $current_time | ${bin_name} is running! ] /g" "${moddir}/module.prop"
  fi
}

stop() {
  local _pid=$(get_running_pid ${bin_name})
  if [ -n "${_pid}" ]; then
    kill "${_pid}"
    log "${bin_name} stopped!"
  fi
  rm -f "${scripts_dir}/${bin_name}.pid"
}

start_inotifyd() {
  PIDs=($($busybox pidof inotifyd))
  for PID in "${PIDs[@]}"; do
    if grep -q "${bin_name}.inotify" "/proc/$PID/cmdline"; then
      kill -9 "$PID"
    fi
  done
  inotifyd "${scripts_dir}/${bin_name}.inotify" "${moddir}" >> "/dev/null" 2>&1 &
}