# Untangling data and code

They are "the same" in the sense that either can be the other, but
pragmatically they "mean" different things.

- Data
  - Good for expressing/capturing intent?
  - often handles the "caching" part of "namespaces and caching"?
  - "well structured"
   - arrays
   - maps
   - long tables
  - Good for describing exceptions?
  - Good for describing expectations?

- Code
  - More "powerful"
  - More "brittle"?
  - Harder to manipulate programmaticly?
  - Good for definitions?
  - Good for translation?

## Questions

- When is a DSL better than raw data?
 - Is my time log as it currently exists better than raw YAML or something?
 - Of course it depends on the details, but in what particular ways?
- When is "data" better?
 - My intuition says if there's a lot of something it should be "data"
  - Lists of regions, realms, services
- When is "actual code" better?
 - What does that even mean?

## Conflicting contexts

- Static definitions
 - Structure
 - Relationships (a kind of structure?)

- Dynamic definitions
 - Transform
 - Problem resolution (a kind of transform?)

- Protocols
 - Definitions
 - Transmissions (transactions, stream content)

- Engines
 - Talk to it via a protocol, it does stuff?

# The problem of "change control"

Change is the differences between times. Change control is the aspiration
towards control of the future.

- Change the list of regions, change "where" things are deployed
- Change the list of services, change "what" is deployed
- Change the monitors, change what is seen
- Change the alerts, change what is loud
- Change the definition, change what is meant/said
- Change the schema, change the protocol

# beyond categories

- 'levels' of intent
- use vs reference
- "code" vs "data"
- "template language" ugh
 - content vs representation?
 - format vs meaning?
 - syntax vs symantics?
