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
    -e "console.log JSON.stringify ($topic $testData), 0, 2 " &&
  coffee -p -b "$topic.coffee" | pbcopy

  #coffee -r "./$topic.coffee" \
  #  -e "
  #for [args..., expect] in ($topic.tests or= []).push $testData
  #  result = $topic args...
  #  console.log [args, expect, result].map(JSON.strinigfy).join '\n'
  #"
done
