# Meta Object Protocol notes

Trying to reconstruct that paper about the N different types of
object-orientation.

# Object Oriented definition elements

## Encapsulation

Grouping of data with the functions which are responsible for it.

## Abstraction

Separation/isolation of interface and implementation.

### Explicit Interface Declaration

### Member setter/getter functions

### Unknown method handling

## Inheritance

"Child is like Parent except/but also ..."

### Behavior inheritance

Child shares Parent's code when possible.

### State inheritance

Child shares Parent's state when not overwritten.

This is usually used for default values in languages where object state and
object methods do not share a namespace. I'm against it.

## Poly-morphism

Sub-classes are interchangable and their behaviors may differ as long as they
don't violate interface expectations.

# Not exactly OO features

## Type coercion

User of an object does not need to know the exact type of the object. The
object's behavior is modulated by its type(s).

    "one" + "two" isnt 1 + 2

## Operator overriding

It's more of a syntax extension feature. Should be used sparingly and should
cleave to the principle of least surprise.

## Mix-in/Role

Not sure about this yet.
