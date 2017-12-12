{suite, test, assert} = require 'rdf/lib/setup-testing'

makeCategorized = (namesAndCategories) ->
  {name, category} for name, category of namesAndCategories

someDishes = makeCategorized
  lasagna:   'italian'
  spaghetti: 'italian'
  taco:      'mexican'
  enchilada: 'mexican'
  burger:    'american'
  pizza:     'american'

someDiners = makeCategorized
  Esmarelda: 'italian'
  Dave: 'american'
  Pablo: 'mexican'

suite 'menu-maker', (suite, test) ->
  { makeMenus } = require '..'

  suite 'base cases', (suite, test) ->
    test 'no dishes, no customers', ->
      assert.equal (makeMenus [], []).length, 0

    test 'no diners', ->
      assert.equal (makeMenus someDishes, []).length, 0

    test 'no dishes', ->
      assert.throws (makeMenus [], someDiners).length

  test 'three diners, six dishes', ->
    assert.equal (makeMenus someDishes, someDiners).length, 8
