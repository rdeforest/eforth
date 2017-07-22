topic=$1
testData="$*"

if [ ! -e "$topic.coffee" ]; then
  ( echo "module.exports ="
    echo "  $topic = () ->" ) > "$topic.coffee"

  screen vi "$topic.coffee"
fi

while read -p "$testData > " newTestData; do
  if [ "$newTestData" ]; then
    testData="$newTestData"
  fi

  coffee -r "./$topic.coffee" \
    -r "./checker.coffee" \
    -e "checker.test $topic, $testData" &&
      pbcopy < $topic.coffee
done
