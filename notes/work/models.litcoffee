    AWS = require 'aws-sdk'

    singletons =
      ResourceType: {}

    class Singleton
      constructor: (info) ->
        {@name} = info

        if exists = singletons.ResourceType[@name]
          return exists

        singletons.ResourceType[@name] = this

    class ResourceType extends Singleton
      constructor: (info) ->
        info.subset = "ResourceType"

        super info


    class Resource:
      constructor: (info = {}) ->
        {@arn} = info
