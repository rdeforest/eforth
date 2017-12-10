module.exports = (ActiveObject) ->
  root = new ActiveObject id: 1, name: 'root', comment: ""
    .addProps
      name:
        comment: "$sys.oNames[obj.name] => obj"
        optional: true
      comment:
        comment: """
          Including a comment on an object helps in maintaining the context
          in which the object was conceived and implemented.
        """
        optional: true

    .addMethods


      name:
        code: """
          (newName) ->
            self.
        """
      comment:
        code: """
          (newComment) ->
            if newComment
              comment = newComment

            comment
        """

  {root}

###
  sys.addMethod
    accessor:
      comment: "query or change a property of an object"
      code: """
        (propName, newValue) ->
          if newValue and sender is $sys
            @[propName] = newValue
            return self

          @[propName]
      """
###
