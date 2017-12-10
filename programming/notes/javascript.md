execution context:

  global
    function
      function
        ...

'this' is not part of the var search path

* Other than 'global' type objects, there may not be a way to manipulate execution context
* But that said, node's 'vm' module might ... something something

If we're looking for a way to control exposure of instance vars (and we are),
we may wish to assign a short var name to that role. $ is overloaded and
needed for global object names, but _ might be ok?

Example usage:

```coffee-script

    $root.addProp, _, 'description'

    $root.addMethod, 'addProp', 
      (definer, pName, {info} = {getter: true, setter: true}) ->
        _.props[definer][pName] = info;

    $visible.addMethod, 'description', """
        (newDescription) ->
          oldOwner = _.owner
          
          if newOwner 
            if $acl.check.setOwner perms, this
              _.owner = newOwner

          oldOwner
    """


```
