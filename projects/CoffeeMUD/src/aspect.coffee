###

"X delegates to Y and Z"
- combines X, Y, Z

"Y expects X to delegate to Z"
- needs Y, Z

###

module.exports =
  combines: (subject, aspects...) ->
    for aspect in aspects
      subject["as#{aspect.name}"] = new aspect subject

    return subject

  needs: (delegate, aspects...) ->
    for aspect in aspects
      name = aspect.name
      delegate["our#{name}"] = delegate.these["as#{name}"]

    return delegate

