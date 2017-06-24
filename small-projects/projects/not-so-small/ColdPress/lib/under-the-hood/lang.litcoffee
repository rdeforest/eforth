Naturally, ColdPress works with any language which readily compiles to
JavaScript. The ColdLanguage class handles this. Each language interface will
have to handle ColdMUD-isms its own way.

- convert '#123' object references into ColdObjRef thingie
- convert '$foo' into lookup by name and ref creation

    class ColdLanguage
      compiler: (code) ->
        
But of course we prefer the CoffeeScript dialect

    class ColdCoffee extends ColdLanguage
      compiler: (code) ->

