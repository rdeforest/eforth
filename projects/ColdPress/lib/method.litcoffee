## Method

    class ColdMethod
      constructor: (info) ->
        { @definer, @name
          @argNames = []
          @code = ""
          @compiler = ColdCoffee.compiler
        } = info

        @fn = @compiler @code

