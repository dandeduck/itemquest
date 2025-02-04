./run.sh & fswatch -o ./src ./priv/public -e "sql.gleam" | xargs -n1 './rerun.sh'
