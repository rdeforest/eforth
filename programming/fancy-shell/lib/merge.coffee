# Deep merge two objects. Traverse namespace of second object and copy its
# members into the first.
#
#    foo = bar: boop: true, baz: "blart"
#    merge foo, bar: baz: "bumble"
#
#    foo.bar.baz => "bumble"
#    foo.bar.boop => "true"
#

module.exports = merge = (dst, src) ->
  if 'object' isnt typeof dst
    throw new TypeError "Destination is not an object"

  if 'object' isnt typeof src
    throw new TypeError "Source is not an object"

  for k, v of src
    if 'object' is typeof v
      if 'object' isnt typeof dst[k]
        dst[k] = {}

      merge dst[k], src[k]
    else
      dst[k] = src[k]

  dst

