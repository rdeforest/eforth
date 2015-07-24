inotifywait -mr -e create src/css | while read watched event subject; do
  rm -rf dist/css
  mkdir dist/css

  find src/css -type f -name '*.css' |
    while read s; do
      d=$(echo "$s" | sed 's/src/dist/').text=css
      cp -v "$s" "$d"
    done

  sleep 1
done
