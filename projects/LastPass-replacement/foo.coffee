rdelay = (x) ->
  delay = Math.random() * 10000
  Promise (resolve, reject) ->
    delayed = ->
      console.log x
      resolve x
    setTimeout delayed, delay

module.exports =
  rdelay: rdelay

#result = rdelay n for n in [1..10]

