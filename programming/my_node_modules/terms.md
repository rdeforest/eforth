Having some trouble with terminology again, so...

# Class vs Instance

All objects are both classes and instances. The distinction here is about the
context within which they are used.

## Instance

An object which does a thing. It may be a Class or not. If it's a class, one
of the things it does is create more instances. The instances it creates may
themselves be Classes.

## Class

- AKA 'Constructor'.
- Knows how to create Instances.
- Class : cookie cutter :: Instance : cookie

A class is also an instance of the concept of a class.

To address an object as a class:

```coffee

class Example

Class Example
  .doClassThing()

```

## Inheritance

- Instances
  - inherit from their parent
    - which is set by their class and
    - is (probably?) not the same as their class

An instance is not a child of its constructor/class, it is a child of its
prototype.

- Classes
  - Are instances of a MetaClass
  - Inherit their instance-construction behaviors from their prototype
  - Their constructor is a MetaClass
  - Their prototype is set by their metaParent

