I'm not an addict...

    _ = require 'underscore'

Which objects does the subject inherit from, including itself?

(The spec calls this the 'prototype chain'.)

    exporting =
      ancestors: ancestors = (subject) ->
        if subject is null or subject is undefined
          return []

        ancestorList = [subject]

        while parent = Object.getPrototypeOf subject
          ancestorList.push parent
          subject = parent

        return ancestorList


Which object controls this inherited object member?

      definedOn: definedOn = (subject, name) ->
        for parent in ancestors subject
          prop = Object.getOwnPropertyDescriptor parent, name

        return undefined


It's nice to pretty-print things sometimes:

      nativeDef: nativeDef = (name) -> "function #{name}() { [native code] }"

      isNative: isNative = (fn) ->
        fn.toString() is nativeDef fn.name

      renderFn: renderFn = (fn, name = fn.name) ->
        if isNative fn
          args = "#{fn.length} args"
          code = '[native]'
        else
          code = fn.toString()
          [matched, name, args] =
            code.match /^function ([^ ]*)\(([^)]*)\)/
          code = '...'

        "#{name}(#{args}) { #{code} }"

      renderData: renderData = (data) ->
        switch data
          when null then 'null'
          when undefined then 'undefined'
          else
            switch typeof data
              when 'function' then renderFn data
              when 'object'   then "{#{(Object.keys data).length} keys}"
              else                 JSON.stringify data

        
      renderParent: renderParent = (parent, name) ->
        parentName = name or parent?.constructor?.name or '(unknown parent)'
        parentName + ":\n" +
        renderMethods(parent) +
        renderProps(parent)

      renderMethods: renderMethods = (obj) ->
        (for propName in Object.getOwnPropertyNames obj
          propVal = obj[propName]

          if 'function' is typeof propVal
            "  #{renderFn propVal}")
          .filter (e) -> e
          .join "\n"

      renderProps: renderProps = (obj) ->
        (for propName in Object.getOwnPropertyNames obj
          propVal = obj[propName]

          if 'function' isnt typeof propVal
            "  #{propName}: #{renderData propVal}")
          .filter (e) -> e
          .join "\n"

      renderObj: renderObj = (subject) ->
        (for parent in (ancestors subject).reverse()
          if parent is subject
            renderParent subject, '(itself)'
          else
            renderParent parent
        ).join "\n\n"


That's what we're doing here.

    install = -> _.extend global, exporting
    _.extend module.exports, exporting, install: install

