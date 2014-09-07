# contact wei.zhang@weimob.com

dir=$(cd "$(dirname "$0")"; pwd)
pushd $dir;
sh daycheck.sh /data/log/mysql_general_log.log "`date '+%y%m%d'`"
popd;
