#!/bin/bash
HASH=$(date +%Y%m%d%H%M%S)
BASE_FILENAME=fovcalc.$HASH
JS_FILENAME=$BASE_FILENAME.js
CSS_FILENAME=$BASE_FILENAME.css
INPUT_JS=(
  fovcalc.js
)

mkdir -p docs

rm docs/*

#uglifyjs -b --warn "${INPUT_JS[@]}" > docs/$JS_FILENAME &&
  #echo $JS_FILENAME generated
cp src/fovcalc.js docs/$JS_FILENAME &&
  echo $JS_FILENAME created

cp src/fovcalc.css docs/$CSS_FILENAME &&
  echo $CSS_FILENAME created

FAVICON_B64=$(cat favicon.png | openssl base64 | tr -d '\n') && echo "Base64-encoded favicon"

sed -e "s/fovcalc.css/$CSS_FILENAME/;s/fovcalc.js/$JS_FILENAME/;s|favicon.png|data:image/png;base64,$FAVICON_B64|;s|http://localhost:9933||" src/fovcalc.html > docs/index.html &&
  echo Filenames replaced in docs/index.html

cp src/md5unicode.js docs/
cp src/*.svg docs/
