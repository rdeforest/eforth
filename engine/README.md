# A 'physics' simulator

A framework for iterating object interactions. Each iteration starts with a
'tick' event dispatched to all 'actors', which themselves may start events of
their own. As events propagate they collect changes requested by participants
which will be made official once all event propagation completes.

# Object model

## Event

An event has
 - parent event aggregating sub-event results or null for ticks
 - source participant
 - destination participant
 - zero or more changes which will come about if the whole event tree succeeds

## Participant

A participant subscribes to, receives and generates events.

### Actor

An Actor is a Participant which subscribes to tick events.

### Standard participants

- world: generates ticks

## Change

A change is a function called when an event chain succeeds.

# Usage
