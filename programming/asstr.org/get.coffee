request    = require 'request'
htmlparser = require 'htmlparser2'

URL_BASE   = 'https://www.asstr.org/~Kristen/'

stories    = {}
categories = []

padIndexNum = (n)       -> n.toString().padStart 2, 0
makeURL     = (n, fn)   -> fn padIndexNum n
indexURL    = (n)       -> makeURL n, (nn) -> "#{URL_BASE}/#{nn}/index#{nn}.htm"
storyURL    = (n, name) -> makeURL n, (nn) -> "#{URL_BASE}/#{nn}/#{name}.txt"

makeElement = (type, name, attributes) ->
  parent = currentElement()
  el = {type, name, attributes, data: '', parent}
  (parent.children ?= []).push el
  el

myDomHandler = (cb, options, elementCB) ->
  dom = type: 'dom', name: 'dom', data: ''
  tagStack = [dom]
  currentElement = -> tagStack[-1..][0]

  onopentag:  (name, attributes) ->
    type = if name in ['script', 'style'] then name else 'tag'
    tagStack.push el = makeElement type, name, attributes, parent

  ontext:     (data)             ->
    if currentElement
    (makeElement 'text', '', {}, currentElement()).data = data

  onclosetag: (name)             ->
    el = tagStack.pop()
    el.data = '' if ' ' is el.data = el.data.trim().replace /\s+/, ' '
    return

  onend: -> cb dom

#parser = new htmlparser.Parser handlerWrapper(); parser.parseComplete result.b

getIndex = (n) ->
  url     = indexURL n
  parser  = new htmlparser.Parser myDomHandler findStories

  request url, (err, response, body) -> parser.parseComplete body

getStory = (indexNum, name) ->
  url = storyURL indexNum, name

  request url, (err, response, body) -> addStory {indexNum, name, body}

domWhen = (pred) -> (fn) ->
  traverseDom (el) ->
    fn el if pred el

traverseDom = (fn) ->
  recurse = (dom, elementsSeen = 0) ->
    for el in dom
      nextStep = (fn el) or {}
      console.log el.name, nextStep

      elementsSeen += 1 + (nextStep.seen or 0)

      switch
        when nextStep.skip  then continue
        when nextStep.abort then return nextStep
        when nextStep.up    then return up: nextStep.up - 1, seen: elementsSeen

      if el.children
        recurse el.children, elementsSeen

    return seen: elementsSeen

   
extractStoryInfo =
  traverseDom (el) ->


findStories =
  traverseDom (el) ->
    true and
      el.name        is 'p'       and
      el.align       is 'JUSTIFY' and
      el.parent.name is 'body'    and
      extractStoryInfo el

if require.main is module
  {env, argv} = require 'process'

else
  Object.assign exports,
  fns: { padIndexNum, makeURL, indexURL, storyURL, makeElement, myDomHandler,
         getIndex, getStory, domWhen, traverseDom, extractStoryInfo, findStories }
  { stories, categories } 
