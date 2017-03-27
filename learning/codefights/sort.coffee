input = [4,7,5,8,6]

var_a = 0

while var_a < input.length
  var_b = var_a + 1

  while var_b < input.length
    if input[var_a] > input[var_b]
      console.log "#{var_a}:#{var_b} swapping #{input[var_a]} for #{input[var_b]}"
      var_c = input[var_a]
      input[var_a] = input[var_b]
      input[var_b] = var_c
      var_b = var_a
    else
      console.log "#{var_a}:#{var_b} leaving #{input[var_a]} and #{input[var_b]} alone"

    var_b++

  var_a++

console.log input
