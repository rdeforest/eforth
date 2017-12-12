qw = (s) -> s.split /\s+/g

e =
  wordLength : "Empty word list is meaningless."

  wordType   : (word) ->
    "Unexpected word type '#{typeof word}'. Expected string or array."

  wordKind   : (kind) ->
    "'#{kind}' is not a known word kind. Expected #{English.list English.pluralWordKinds, conjunction: 'or'}"

plural = (kind) ->
  kind[0] = kind[0].toUpperCase()

  throw new e.wordKind kind unless 'function' is typeof fn = @["plural#{kind}"]

  fn.bind @

Object.assign exports, {English},
  comment: """
  """

English =
  list: (items, opts = {}) ->
    { separator   = ','
      space       = ' '
      conjunction = 'and'
      serialComma = false # https://en.wikipedia.org/wiki/Serial_comma
    } = opts

    switch items.length
      when 0 then ''
      when 1 then items[1]
      else
        [most..., last] = items
        commasOn = -2
        commasOn++ if serialComma

        most[..commasOn]
          .map    (s) -> s + separator
          .concat conjunction, last
          .join   space

  pluralNoun: (noun, count) ->
    pluralWord noun, English.pluralNoun.formula

  pluralVerb: (verb, count) ->
    pluralWord verb, English.pluralVerb.formula

  pluralWord: (word, formula, exceptions, count) ->
    count = count.length if Array.isArray count

    return word if count is 1 or count.length is 1

    if plural = exceptions[word]
      if words is true
        word
      else
        plural
    else
      formula word

English.pluralWordKinds = Object
  .getOwnPropertyNames English
  .filter (name) -> name.startsWith 'plural'
  .map (name) -> name[6..]

English.pluralNoun.exceptions =
  proof: 'proves'
  foot: 'feet'
  goose: 'geese'
  louse: 'lice'
  man: 'men'
  mouse: 'mice'
  tooth: 'teeth'
  woman: 'women'

qw '''
bison buffalo carp cod deer duck fish kakapo pike salmon sheep shrimp squid
swine trout
aircraft watercraft spacecraft hovercraft
''' .map (word) -> English.pluralNoun.exceptions[word] = true


English.pluralNoun.regular = [
  {regex: /(s|sh|ch)$/,   formula: (w) -> w       +  'es'}
  {regex: /-by$/,         formula: (w) -> w       +   's'}
  {regex: /([^aeiouy]o$/, formual: (w) -> w       +  'es'}
  {regex: /^[a-z].*y$/,   formula: (w) -> w[..-2] + 'ies'}
  {regex: /[aeiou]fe$/,   formula: (w) -> w[..-3] + 'ves'}
  {regex: /f$/,           formula: (w) -> w[..-2] + 'ves'}
  {regex: /ies$/,         formula: (w) -> w              }
]

English.pluralNoun.formula = (noun, count) ->
  return noun if count is 1

  for pattern in English.pluralNoun.regular
    if pattern.regex.match noun
      return pattern.formula noun

  switch noun[-1..]
    when 'y'
      [noun, noun[..-2] + 'ies']
    when 'h'
    else
      [noun, noun + 's']

English.pluralVerb.exceptions =
    is: qw 'is are'
    has: qw 'has have'

English.pluralPrep.exceptions = {}
