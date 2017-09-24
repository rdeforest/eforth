Teasing apart the separations of concerns...

(because not invented here?)

- storable freeze/thaw
 - does
  - freeze
  - thaw

- session
 - has
  - protocol
  - state from protocol

- protocol
 - maps a key-value store inteface to an implementation

- world
 - a particular collection of objects
 - addressed via a url like file:///./worlds/finch&fromat=yaml&v=1
 - created from url, dependencies
 - creates session
 - creates, stores, fetches, deletes storables

