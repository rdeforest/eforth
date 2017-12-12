# Main function

    makeMenus = (dishes, diners) ->
      permuteChoices calculateChoices dishes, diners

# Permute choices

I'm guessing it's safe to assume this "app" won't be used for tables of more
than a few dozen diners. Stack exhaustion could be a problem at a place like
Hogwarts. When V8 gets
[proper tail-calls](https://github.com/kangax/compat-table/issues/819)
this won't be an issue.

    permuteChoices = ([choice, choices...],
                      menus = [Object.assign [], reserved: {}]) ->

      extended = extendMenus menus, choice

      unless choices.length
        return extended

      permuteChoices choices, extended

    extendMenus = (menus, choice) ->
      {name: dinerName, choices: dinerChoices} = choice

      menus = [].concat (
        menus.map (menu) ->
          for dishName, count of dinerChoices
            (reserved = Object.assign {}, menu.reserved)[dishName] ?= 0

            continue unless avail = count - reserved[dishName]
            reserved[dishName]++
            Object.assign (menu.concat {dinerName, dishName}), {reserved}
      )...

## Categorize

Given a list of items with members 'name' and 'category', build a dictionary
of categories containing dictionaries of counts of names.

    addToCategory = (acc, {name, category}) ->
      bumpDeepCounter acc, [category, name]
      acc

    categorize = (items) -> reduce items, {}, addToCategory

## Calculate choices

For each diner, obtain a list of dishes they could be served.

    calculateChoices = (dishes, diners) ->
      inventory = categorize dishes
      table     = categorize diners

      diners.map ({name, category}) ->
        name:    name
        choices: inventory[category]

## Beautifier

    menusToText = (menus) ->
      menus
        .map (menu) ->
          menu
            .map ({dinerName, dishName}) ->
              "#{dinerName}: #{dishName}"
            .join '\n'
        .join '\n--\n'

## Readability function

One feature of Perl I miss is auto-vivification. I understand why neither
JavaScript nor CoffeeScript have it, but still.

In this case I combine auto-vivification with an operation on the leave in
question. This allows me to "increment or set to 1" in one expression.

    autoVivOp = (root, [key, keys...], value, op) ->
      if keys.length
        root[key] ?= {}
        autoVivOp root[key], keys, value
      else
        root[key] ?= value
        root[key] = op root[key] if op

      return root

    addOne = (n) -> n + 1

    bumpDeepCounter = (tree, keys) ->
      autoVivOp tree, keys, 0, addOne

The default reduce is Array::reduce(reducer, baseCase).

My reduce function puts the reducer at the end so you don't have to wrap it in
parentheses when supplying a baseCase.

Comparison:

```coffee
  array.reduce ((acc, el) -> acc[el.name] = el), {}

  reduce array, {}, (acc, el) -> acc[el.name] = el
```

    reduce = (array, baseCase, reducer) ->
      array.reduce reducer, baseCase

# Test functions and data

    decategorize = (categorized) ->
      items = []

      [].concat (
          for catName, category of categorized
            [].concat (
              for itemName, count of category
                [1..count].map -> { name: itemName, category: catName }
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

# Exports

    Object.assign exports, {
      categorize, decategorize
      makeMenus, calculateChoices
      testDiners, testDishes
      permuteChoices
      test: -> makeMenus testDishes, testDiners
      reduce
    }

