while inotifywait -mr src/css; do
  rm -rf dist/css
  mkdir dist/css

  find src/css -type f -name '*.css' -print0 |
    xargs -0 -I{} cp "{}" "dist/cs/{}.text=css"
done
