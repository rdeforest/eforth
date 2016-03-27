$(document.head)
  .append $("<style>")

ss = document.styleSheets
styleSheet = ss[ss.length - 1]

styleSheet.insertRule rule for rule in [
  """ div.intensified {
        border: solid black 1px;
      } """,
  """ div.active {
        border-color: red;
      }
  """,
  """ div.intensified .menu {
        display: none;
      }
  """,
  """ div.active .menu {
        display: inline-block;
      } """
  ]

cardLinks = ->
  $('.article-table a')
    .filter (idx, el) ->
      href = $(el).attr 'href'
      cardName = el.innerText
      cardName.replace " ", "_"
      decodeURIComponent href is '/wiki/' + cardName

$("span.mw-headline span.button").each (i,e) -> e.click()

persistantProp = (name, prop) ->
  get: ->
    (JSON.parse localStorage[name])[prop]

  set: (newValue) ->
    data = JSON.parse localStorage[name]
    data[prop] = newValue
    localStorage[name] = JSON.stringify data

persistObject = (name, defaults = {}) ->
  newObj = {}

  if exists = localStorage[name]
    data = JSON.parse exists

  for k, v of defaults
    Object.defineProperty newObj, k, persistantProp name, k
    newObj[k] = v

  for k, v of data
    if not k in Object.keys defaults
      Object.defineProperty newObj, k, persistantProp name, k
    newObj[k] = v

  newObj

cardLibrary = persistObject 'cardLibrary',
  name: {}
  id: {}
  url: {}
  have: {}
  deck1: {}
  deck2: {}
  deck3: {}

matchCard = (card) ->
  maybe = []

  for k, v of cardLibrary
    if found = v[card[k]]
      maybe.push found

  maybe

upsertCard = (card) ->
  cardExists = matchCard card

  if cardExists.length is 0
    return addCard card

  if cardExists.length is 1
    updateCard cardExists[0].id, card

  throw new Error "upsertCard(#{card}): ambiguous match (#{cardExists})"

menuItem = (el, label, fn, card) ->
  link = $("<a>#{label}</a> ")
  link.on 'click', fn card
  link.addClass label if cardLibrary[label][card.id]

toggle = (info) ->
  for bin, card in info
    cardLibrary[bin][card.id] = not cardLibrary[bin][card.id]

menuItems =
  have:  (card) -> toggle have:  card
  deck1: (card) -> toggle deck1: card
  deck2: (card) -> toggle deck2: card
  deck3: (card) -> toggle deck3: card

processPage = (page, callback) ->

queryCard = (cardName, callback) ->
  cardName.replace ' ', '_'
  cardName = encodeURIComponent cardName
  cardName.replace '\'', '%27'
  url = '/wiki/' + cardName
  iframe = $("<iframe src=\"#{url}\">")
  iframe.style.display = "none"
  iframe.on 'load', processPage iframe.contents(), callback
  $(document.body).append iFrame

getCard = (info, callback) ->
  known = matchCard info

  if known.length isnt 1
    queryCard cardName, callback
  else
    callback known[0]
    
menu = (el) ->
  getCard name: el.innerText, (card) ->
    menuItem el, label, fn, card for label, fn of menuItems

linkIntensifies = (el) ->
  $ el.parentElement
    .append div = $("<div>")

  div.append el

  div
    .on 'mouseenter', -> $(div).addClass 'active'
    .on 'mouseleave', -> $(div).removeClass 'active'
    .addClass 'intensified'
    .append (menu el)...

cardLinks().each (idx, el) -> linkIntensifies el

window.laa =
  cardLibrary: cardLibrary
  cardLinks: cardLinks
  revealMenu: revealMenu
  linkIntensifies: linkIntensifies
  styleSheet: styleSheet
