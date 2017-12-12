# Shouldn't have to brute force this, it's a combinatorics problem.

keys   = Object.keys

reduce = (l, acc, fn) -> l.reduce fn, acc

categorize = (items) -> reduce items, {},
  (acc, {name, category}) ->
    (cat = acc[category] ?= {})[name] = (cat[name] ? 0) + 1; acc

calculateDemand = (inventory, table) ->
  for category, diners of table
    if not avail = inventory[category]
      throw new Error "Diners are requesting unknown dish type '#{category}'"

    if keys(inventory[category]).length < wanted = (keys diners).length
      throw new Error "Cannot satisfy demand for #{wanted} dishes of type #{category}"

    "#{category}": wanted

calculateChoices = (diners, inventory) ->
  diners.map ({name, category}) ->
    name:    name
    choices: inventory[category]

makeChoices = (dishes, diners) ->
  inventory = categorize dishes
  table     = categorize diners
  choices   = calculateChoices diners, inventory


_makeMenus = (choices) ->
  noMenu  = Object.assign [], reserved: {}
  menus   = [noMenu]

  for choice in choices
    console.log "choice:", choice
    {name: dinerName, choices: dinerChoices} = choice

    menus = [].concat (
      menus.map (menu) ->
        console.log "menu:",         menu
        console.log "dinerChoices:", dinerChoices

        for dishName, count of dinerChoices
          if not menu.reserved
            throw new Error "missing reservations"

          reserved = menu.reserved[dishName] ?= 0

          unless avail = count - reserved
            console.log "#{dishName} left: #{avail}"
            continue

          ((extended = menu.concat {dinerName, dishName})
            .reserved = Object.assign {}, menu.reserved)[dishName]++

          extended
    )...
  menus

makeMenus = (dishes, diners) ->
  _makeMenus makeChoices dishes, diners
    .map (menu) ->
      menu
        .map ({dinerName, dishName}) ->
          "#{dinerName}: #{dishName}"
        .join '\n'

decategorize = (categorized) ->
  items = []

  [].concat (
      for catName, category of categorized
        [].concat (
          for itemName, count of category
            [1..count].map -> {name: itemName, category: catName}
        )...
    )...

testDishes =
  decategorize
    italian:  lasagna:    1, spaghetti:  1
    mexican:  enchiladas: 1, quesadilla: 1, burrito: 1
    american: burger:     1, pizza:      1
    salad:    garden:     1, aztec:      1

testDiners =
  decategorize
    italian: Alice: 1, Bob: 1
    mexican: Robert: 1
    american: Barkley: 1
    salad: Nicole: 1

Object.assign exports, {
  categorize, decategorize
  calculateDemand, calculateChoices
  makeMenus, makeChoices
  testDiners, testDishes
  _makeMenus
  test: -> makeMenus testDishes, testDiners
}

