#!/bin/bash
HASH=$(date +%Y%m%d%H%M%S)
BASE_FILENAME=fovcalc.$HASH
JS_FILENAME=$BASE_FILENAME.js
CSS_FILENAME=$BASE_FILENAME.css
INPUT_JS=(
  fovcalc.js
)

mkdir -p build

rm build/*
rm ./index.html
rm ./fovcalc.*

#uglifyjs -b --warn "${INPUT_JS[@]}" > build/$JS_FILENAME &&
  #echo $JS_FILENAME generated
cp src/fovcalc.js build/$JS_FILENAME &&
  echo $JS_FILENAME created

cp src/fovcalc.css build/$CSS_FILENAME &&
  echo $CSS_FILENAME created

FAVICON_B64=$(cat favicon.png | openssl base64 | tr -d '\n') && echo "Base64-encoded favicon"

sed -e "s/fovcalc.css/$CSS_FILENAME/;s/fovcalc.js/$JS_FILENAME/;s|favicon.png|data:image/png;base64,$FAVICON_B64|;s|http://localhost:9933||" src/fovcalc.html > build/index.html &&
  echo Filenames replaced in build/index.html

cp ./build/* ./
