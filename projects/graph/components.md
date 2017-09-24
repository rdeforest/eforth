Teasing apart the separations of concerns...

(because not invented here?)

- The object model itself
 - serialization/deserialization
 - Contract is ${world}::{freeze,thaw}
 - A "world" is a collection of objects which "know" each other in some sense?
  - World::freeze(obj) returns a string which
  - World::thaw(str) interprets (str) as an installable package

- stores in general
 - Ingesting/initializing persisted objects
 - committing changes
 - reverting changes?

- Encapsulating a specific store (location, exceptions to defaults)
