###

About the "asFoo" pattern of mixins

- entity.asAspect is an instance of an Aspect which refers to its delegator as @these
- Aspects refering to other objects should reference the other objects' aspects, not their ".these"
- If an aspect needs to address its aggregation's other aspects it should capture them in its contructor

###

class Aspected
  constructor: (aspects...) ->
    for aspect in aspects
      @["as#{aspect.name}"] = new aspect @

  _needs: (aspects...) ->
    for aspect in aspects
      name = aspect.name
      @["our#{name}"] = @these["as#{name}"]

