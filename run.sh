gleam run -m tailwind/run &

gleam run -m squirrel
files=$(find src -type f -name "sql.gleam")
gleam format $files

gleam run &
