# Description

Find permutations of categorized menu items which meet the requirements of
diners.

Both dishes and customers are an object with a name and category.

I could use Underscore, lodash or Ramda, but don't want to add a dependency.

    reduce = (list, acc, merger) -> list.reduce merger, acc

    sum    = (l, ls...) -> l.reduce(((a, b) -> a + b), 0) + if ls.length then sum ls... else 0

    merge  =
    objectFromEntries =
      (entries) -> Object.assign {}, entries...

    placeInCategory = (categories, {name, category}) ->
      (categories[category] ?= [])
        .push name

      categories

    categorize = (items) ->
      reduce items, {}, placeInCategory

    class PickyCustomer extends Error
      constructor: ({name, category}) ->
        super "#{name}'s preference for #{category} cannot be satisfied"

    class ToughCrowd extends Error
      constructor: (diners, category, available) ->
        wanted = diners.length
        super "More diners want '#{category}' (#{wanted}) than we can provide (#{available})"

    listToCounts = (list) ->
      list.reduce ((counts, el) ->
          counts[el] ?= 0
          counts[el]++
          counts
        ), {}

    kitchenWithoutDish = (dish, kitchen) ->
      {name, category} = dish

      unEditedCategory = kitchen[dish.category]
      editedCategory   = unEditedCategory.filter (item) -> item.name is name

      return merge kitchen, editedCategory

    makeMenus = (diners, dishes) ->
      dinersByCategory = categorize diners
      dishesByCategory = categorize dishes

      for category, dishes of dishesByCategory
        (dishesByCategory[category] = counts = listToCounts dishes)

      for category, diners of dinersByCategory
        if diners.length > (avail = sum disheByCategory[category]?) or 0
          throw new ToughCrowd diners, category, avail

      try
        return _createMenus diners, dishesByCategory

      catch e
        return [] if e instanceof PickyCustomer

        throw e

    _createMenus = (diners, dishes, soFar = {}) ->
      if dishes.length < diners.length
        return []

      [diner, diners...] = diners

      menus = []

      for dish in dishesByCategory[diner.category] ? []
        subMenus = []

        if diners.length
          subMenus = createMenus(withoutDish(dish, dishes), diners)

        subMenus = [Object.assign {}, soFar, "#{diner.name}": dish.name]

    module.exports.makeMenus = makeMenus
