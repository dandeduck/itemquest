echo "restarting..."

for i in `ps -ef | grep erl | grep -v grep | awk '{print $2}'`; do echo $i; kill -9 $i; done

./run.sh
