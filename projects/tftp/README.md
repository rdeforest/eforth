# TFTP implementation in CoffeeScript on NodeJS

Not much else to say!

## Design

### Models

Name        | Description
------------+------------
Blob        | Transferable object
Session     | A specific transfer attempt
Client      | Initiator of a session
Server      | Other end of a session
ObjectStore | Mapping from names to blobs
Request     | 
Response    | 

### User interface

#### Client

    $ echo "value" | bin/client put "key"
    $ bin/client | get "key"
    value
    $ 

#### Server

    $ bin/server
    Received 'key', size 6
    Sent     'key', size 6
    ^C
    $ 



