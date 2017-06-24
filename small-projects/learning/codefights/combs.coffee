# show = (a, b) ->
#   both = a
#     .split('')
#     .map (c, i) ->
#       switch
#         when c    is '.'    then  b[i]
#         when b[i] is '.'    then  c
#         when b.length <= i  then  '.'
#         else                      'x'
#     .join ''
# 
#   console.log "---\n#{a}\n#{b}\n#{both}"

fit = (a, b) ->
  unless a.length and b.length
    return true

  if "." in [a[0], b[0]]
    return fit a[1..], b[1..]

  false

shift = (comb, offset) -> ".".repeat(offset) + comb

module.exports = combs = (a, b) ->
  [a, b] = [b, a] if a.length < b.length

  if a.length > b.length
    for offset in [1..a.length - b.length]
      if fit a, shift b, offset
        return a.length

  for offset in [1..b.length]
    if (fit shift(a, offset), b)                        or
       (fit shift(b, a.length - b.length + offset), a)
      return offset + a.length
