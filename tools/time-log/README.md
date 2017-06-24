# Time tracking

Based on method I use at work now in which I write my time log in valid
CoffeeScript.

## Syntax

(See example-data.coffee)

# Spec

A log is a module expoting a function which expects to be called with an
argument which is a Logger object providing the functions and objects which
are used to compose a log.

## Logger properties

### Specifiers

(See console-log.coffee)

### q

'q' is a convenience object for 'quickly' referencing common event info. One
might have q.email set to admin: 'email', q.fdrill to admin: 'fire drill',
q.meet.ops to 'admin: meeting: "ops"', etc.



