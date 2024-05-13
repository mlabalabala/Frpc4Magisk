#!/system/bin/sh

scripts_dir="${0%/*}"
. ${scripts_dir}/conf.sh

start() {
  stop
  ${scripts_dir}/${bin_name} -c "${data_dir}/frpc.toml" > ${data_dir}/run.log &
  echo $! > "${scripts_dir}/${bin_name}.pid"
  check_run_status
}

restart() {
  stop
  sleep 3
  start
}

verify() {
  ${scripts_dir}/frpc verify -c "${data_dir}/frpc.toml" >> ${data_dir}/run.log
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    restart
    ;;
  verify)
    verify
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|verify}"
    exit 1
    ;;
esac