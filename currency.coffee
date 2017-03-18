class Perishable
  @dictionary: {}
  @lookupStorageClass: (declaredClass) ->
    Perishable.dictionary[declaredClass]

  @registerPerishable: (name, klass) ->
    @dictionary[name] = klass

  freeze: ->
    return class: @constructor.storageClass, constructorArgs: @serialized()

  thaw: (frozen) ->
    klass = new Perishable.lookupStorageClass frozen.class
    new klass frozen.frozen

Currencies = {}

class CurrencyAmount extends Perishable
  constructor: (@count, @currency) ->

  toString: ->
    [
      @currency.sign @
      @currency.sigil @
      @currency.ones @
      @currency.decimalSepator @
      @currency.cents @
    ].join ''

  sign: ->
    if @count < 0
      "-"
    else
      ""

  @decimalSeparator: -> if @cents then '.' else ''

class DollarAmount extends CurrencyAmount
  @storageClass: "Currency.USD"

  ones: -> (@count - @cents) / 100

  cents: -> @count % 100

  sigil: -> '$'

Currencies.USD = DollarAmount

# example 'JSON'
#
# data =
#   twofiddy:
#     class: "Currencies.USD"
#     frozen:
#       count: 250
