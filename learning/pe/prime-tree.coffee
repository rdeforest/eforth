genericCompare =
  (a, b) ->
    switch
      when a < b then -1
      when a > b then  1
      else             0

class BalancedSortedTree
  constructor: (@comparator) ->
    @values = []
    @comparator or= genericConpare

  insert: (value) ->
    step = idx = Math.ceil @values.length / 2
    while 1 < step = Math.ceil step / 2
      if cmp value, node.value < 0
        idx -= step



    

  delete: (idx) ->

  get: (idx) ->

  find: find = (p) ->
    node = @root

    while node
      if not node.value or p < node.value
        node = node.left

      else if p is node.value
        return true

      else
        node = node.right


  append: (p) ->
    @tail.value = p

    node = @tail
    height = @height @root

    while node.parent
      node = node.parent

      if not node.right
        return @tail = node.right = parent: node

    while node.value
      if node.left.value
        if node.right
          node = node.right
        else
          return @tail = node.right  = parent: node
      else
        
    
###

               8

       4               9

   2       5      10      13

 1   3   6   7  11  12  14  15
