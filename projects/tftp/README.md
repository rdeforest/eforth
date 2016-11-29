# TFTP implementation in CoffeeScript on NodeJS

Not much else to say!

## Design

### Models

Name        | Description
------------+----------------------------
Session     | A specific transfer attempt
Client      | Initiator of a session
Server      | Other end of a session
Blob        | Transferable object
ObjectStore | Mapping from names to blobs
Message     | A packet

### User interface

#### Client

    $ echo "value" | bin/client put "key"
    $ bin/client get "key"
    value
    $ 

#### Server

    $ cat config.json | bin/server
    config = {
      "port": 8069,
      "objectSizeLimit": 65535,
      "keySizeLimit": 1023,
      "objectCountLimit": 1023
    }
    events = [
      { "put": "key", "size": "6" }
      { "get": "key", "size": "6" }
    (user hits ^C)
    ]
    $ 

