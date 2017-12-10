# What now?

The idea is to create a meta-object-protocol which provides the kind of object
interface I'm used to getting from MOO, ColdMUD and such:

Automatic persistence by default
- Persist everything, including methods
 - But how though?
 - uninterrupted "thread"? (yeah)
  - no yields
  - no async calls
 - commit/rollback?
  - complicated much?
 - async hooks?
  - also complicated
 - other?
  - other what?

And maybe also some new things:

- Version control of methods and schemas/interfaces/contracts
- Low-friction self-documentation (a la SmallTalk)

## TOO AMBITIOUS! _*SLAP*_

Ok, fine, but is it really? If I use dependency injection to decouple the
interface from the implementation, maybe it's not such a big deal?

# Contract

## Structural

- Objects define instance state schema

## 'Behavioral'

- Objects publish contracts

# Interfaces

## Node API

### Objects

    MyKeyValueStore =
      create: ->
        store = []

        get = (id

    AObject = require 'ActiveObject'
    
    db = AObject
      .createDb do ->
        db = []

        store:
          create: ->
            { id: db.length, object: db.push {} }

          fetch:  (id) -> db[id]
          delete: (id) -> db[id] = undefined

      .addNamespace do ->
        mapped = {}
        ret =
          lookup: (name)     -> mapped[name]
          store:  (name, id) -> mapped[name] = id
          nextId:            -> mapped.length

    assert $root =  db.lookup          'root'
    assert $sys  =  db.lookup          'sys'
    assert MOP   =  $sys.mop
    assert $root in MOP.ancestors      $sys

    assert myObj =  MOP.create    $root
    assert $root in MOP.ancestors myObj

    assert.equal $sys.mop.children($root).length, 2

    initCalled = 0

    assert child = MOP.create myObj
    assert.equal initCalled, 1

### Methods

    

## REPL

```bash
$ coffee -r ActiveObject
```

Starts the repl with the global and repl objects augmented to give the user a
ColdMUD-like experience, sorta. Input is still treated like code by default,
as if every line started with a ;, but the "$" variable is a function which
takes a string and treats it like a MUD command:

```
coffee> 1+1
2
coffee> $ 'say hello'
Crag says, "hello"
{}
coffee> 
```

### Config

The default config:

```coffee
    module.exports.config =
      dataDir: './aodb' # use a directory called 'aodb' for persistence
```

# Implementation

## Layers

The AO functionality happens at a layer on top of Node+CoffeeScript. This
necessitates some well-defined lingo for avoiding confusion between the
layers. For now the AO prefix will refer to the AO version of a thing and ES
will refer to the ECMAScript version of a thing:

term | meaning
-----|--------
object | something which has properties which associate strings with values
method | a property which has a function value
instance | something which derives functionality from a class
class | something which defines a collection of instances (circular much?)
ESinstance | ECMAScript Object which is an instance of something besides Object
ESclass | ECMAScript class (function)
AObject | The ECMAScript class which defines the behavior of AO objects
AOinstance | An ECMAScript instance of ActiveObject
AOclass | an AOinstance, which has or will have AO children
AOdefiner | the AOclass which 'owns' a method or property

## AO VM

To accomplish the kind of namespace control we want inside AOmethods, every
AOinstance will have its own Node VM module which hosts the state visible to
the methods that instance and its ancestors define.

## AO instances

Every AO instance has a Symbol() used to access entities specific to it.
Information about properties defined by object a are stored in
a[AO].data[instanceSym]. The Node VM objects for each method definer are
maintained on that definer, indexed by instance symbol.

vim: tw=78:fo+=t
