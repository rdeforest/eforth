  - RLM
    - request log monitor

    - Parse HTTP service logs to get metrics
      - requests
      - clients
      - size
      - result
      - S3 bucket
      - etc
      - [datum] per customer is too huge, so it's summarized
      - generates key/value pairs

    - Insert/update Top Talker heap

    - Ship out and clear heap _counters_ every 10 seconds
      - Entries left in place to improve data quality

    - Processes 2000 entries per second (!)
      - Intentionally single-threaded to limit blast radious

    - Run by other teams on the machines which generate the logs
      - CloudFront
      - S3
      - R53

  - NFC
    - NetFlow collector
    - highly sampled, aggregated, fuzzy data

  - RDS
    - Relational Data Service, MySQL
    - All data inserted into two stacks for redundancy
    - Primary regions have 60 instances per stack, 120 total with redundancy
      - 1.4 TB per instance
    - Aggregators insert data into both stacks simultaneously
