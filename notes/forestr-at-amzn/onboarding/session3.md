# NetFlow Collectors

  - Provided by routers
  - contains and aggregates on packet tuples
    - protocol, src/dst port/ip, flags, interface
  - includes totals
    - packets
    - bytes
  - "heavily" sampled (about .02% of total traffic)

# Data flow

  - Router
  - PeakFlow (Arbor device)
    - Only at this place in the path to consume the data
    - Should/will move under Flowbucket
  - Flowbucket
    - Stores flow information in S3
    - distribution to multiple consumers, but we care about NFC
  - NFC
    - Health check -> Flowbalancer -> 'tee config' to S3 -> Flowbucket
    - Polls Router via SNMP to get real byte and packet counters

Special case "on-net en-tras"

  - Router
  - Flowbucket

# Inside the NFC

  - Translate the netflow into a service log
    - uses "netflow converter" to perform the translation
    - breaks flows out into customers (CF, R53, etc)
    - uses dogfish to identify IPs
    - Also converts NetFlow format to a Coral object format
  - RLM process consumes the service log

# More notes

  - Each stack is per-region
    - New routers point to the nearest stack

# Questions

  - CloudFront DNS?
  - Other consumers of Flowbucket?
    - Probably?
