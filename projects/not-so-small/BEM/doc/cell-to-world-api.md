# TODO

- Give this protocol a better name.

# Description

- Used for communication between cells and the platform which hosts them.
- Cell's interface to platform is anything which can convey JSON
- Messages objects have a a "BEM-Message" key
 - In verbose mode (?) includes version and client information?

## Message types

- Query
- Response
- Advertisement (no response expected)

## Cell -> Platform

- How healthy am I?

- How do I 'X'?
  - where 'X' is a priviliged operation (network access, persistence, etc)

- What can I do?
  - Reply contains list of 'X' for above

- Transmit on channel

- (un) Listen on channel

- Channels have no 'persistence'
  - There is no 'Create channel' because that happens the first time a cell sends
  - There is no 'Destroy channel' because that's the same as not sending or listening
  - The channel is just a tag for matching publishers and subscribers

## Platform -> Cell

- Re: How healthy am I?
  - TBD

- Re: How do I 'X'
  - You can't right now, but maybe later
  - You can't and don't ask again

- Re: What can I do?
