Notes for Rails studying

# CodeCademy

  - Associations II
    - Buggy? Weird stuff was happening.
    - Overall not a very satisfying chapter.

## Overall

# Big picture

## Observations

  - The hard part about learning this stuff is my impatience
    - I skip steps, instructions, etc
    - I forget stuff quickly
    - I want to go off and do other stuff
    - Is the Vyvanse actually working?

## MVC

Scope of notes limited to classic HTTP stack for now.

  - Controller: input translator
    - consumes HTTP requests
    - generates events
  - Model: logic
    - consumes events
    - supplies state to views
  - View: output translator
    - triggered by events
    - parameters supplied by models
    - generates HTTP responses

## 'diagram'

    Browser Controller View Model
       |         |      |     |
       S-------->|      |     |
       |         S-----)|(--->|

       # not sure about sync/async stuff here...

       |         |      |<----R
       |<-------)|(-----|     |

# About Ruby

## Questions

  - Private?
  - Single vs double quoted strings?

# About Rails

## Impressions

  - The more I learn, the more I like it
    - "opinionated" is fine when it doesn't conflict with my own stuff

## Questions

  - Directory layout
    - Why are routes under config/ ?
    - Why is db/ not under app/ ?
  - Did I miss the image_tag lesson?
  - Simple relations (has_many / belongs_to) go in the Model file, but...
    - What about more complex relationships?
      - need example :)
  - @item.field vs @field
  - Why item_path(i) instead of
    - i.path()
    - Item.path(i)
    - path(i)
    - path.item()
    - path.item(i)
    - ...
  - Despite how much Rails already does for me, it still seems to have a lot of
    boilerplate
    - ItemsController.prototype.show = (params) -> @item = Item.find params.id
    - Maybe this is just because I'm doing tutorials? Learn to crawl before
      walking?

## Surprised by

  - Got plural/singular thing wrong in the context of views
    - It probably comes naturally outside the context of a tutorial where intent
      may not be obvious.
    - Presumably
      - controller/item.rb manages instances?
      - controller/items.rb manages collections?
      - Or maybe not?
