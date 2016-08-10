models =
  Girl     : './girl'
  Trait    : './trait'
  Item     : './item'
  Building : './building'
  Job      : './job'

(require '../bp') models, (models) ->
  module.exports = models
