# TFTP implementation in CoffeeScript on NodeJS

Not much else to say!

## Design

### Models

Name        | Description                 | Purpose
------------+-----------------------------+------------------------------
Session     | A specific transfer attempt | Hide network protocol details
Server      | Listener for new sessions   |
Blob        | Transferable object         | Handles chunking
ObjectStore | Mapping from names to blobs | Associates names with Blobs
Message     | A packet                    |

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

