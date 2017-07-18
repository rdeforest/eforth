class Finalizer
  constructor: (@create, @use, @destroy) ->
    @resource = @create()

    try
      Promise.resolve @use @resource
        .catch (e) ->
          try
            @destroy @resource
          throw e
        .then ->
          @destroy @resource
    finally
      @destroy @resource

