
models =
  Girl     : "./girl"
  Trait    : "./trait"
  Item     : "./item"
  Building : "./building"
  Job      : "./job"

for name, module of models
  module.exports[name] = require module
