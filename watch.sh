./run.sh & fswatch -o ./src ./priv/public | xargs -n1 './rerun.sh'
