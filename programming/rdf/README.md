# RDF: Really Damn Fine

Name is a work in progress.

# Mission

# Features

## Extending Boxed Types

- String
- Array

## Sideways Objects

Example:

```coffee

hidden = null

class HasComment
  comment: (comment) ->
    [comment, hidden().comment] = [hidden().comment, comment]
    return comment
    
Sideways HasComment, (fn) -> hidden = fn

HasComment Object
  .comment "Almost every object's ultimate ancestor"

class Inspector extends Sideways
  toString: ->

```


