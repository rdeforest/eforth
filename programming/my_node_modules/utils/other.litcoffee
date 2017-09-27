    CoffeeScript = require 'coffee-script'
    examine = require 'utils/examine'

    module.exports = (opts) ->
      if opts.enhanceCoreClasses
        Object.assign Object.prototype, {} # examine stuff

        Object.assign String.prototype,
          left: (width, more = "") ->
            if @length < width
              this + " ".repeat width - @length
            else
              this.substr(0, @length - more.length) + more

          right: (width, more = "") ->
            if @length < width
              " ".repeat width - @length + this
            else
              this.substr(0, @length - more.length) + more

          center: (width, more = "") ->
            if @length < width
              pad = " ".repeat Math.ceil (width - @length) / 2
              (pad + this + pad).substr 0, width
            else
              this.substr(0, @length - more.length) + more


      listDepth: listDepth = (l) ->
        return 0 unless Array.isArray l

        Math.max (l.map (sublist) -> 1 + listDepth sublist)...


      flatten: flatten = (l, depth = 1) ->
        l = [l]  if not Array.isArray l

        return l if not l.length or depth < 1

        l = (flatten el, depth - 1 for el in l)

        l.reduce (a, b) -> a.concat b

      tail: tail = (l, n = 10) -> l[l.length - n ..]

      grep: (pat, ls...) ->
        grouped = ls.length > 1

        ret = for l, idx in ls
          l.filter (s) -> s.match pat

        if not grouped
          flatten ret
        else
          ret

      loadCoffee: (path) ->
        for variation in [path, path + ".coffee"]
          try
            if 'object' is typeof stats = fs.statSync variation
              found = [variation, stats]
              break

        if not found
          try
            where = require.resolve path
            found = [where, fs.statSync where]

        if not found
          throw new Error "Could not resolve #{path} as file or module"

        [where, stats] = found

        CoffeeScript.eval fs.readFileSync(found[0]).toString 'utf-8'



