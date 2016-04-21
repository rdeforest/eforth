What would it cost to run something like Join Robin on AWS?

Factors:

  - User accounts
    - Active
    - Inactive
    - Dead
  - Chat Rooms
    - Tier
    - Member count
  - Chat messages
    - Recipient count (room size)

API:

  - Requests
    - Create account
    - Login
    - Found a Room
    - Register vote
    - Send message to room

  - Notifications
    - Vote results
    - Merge into new room
    - Message received from room

Models:

  - User
    - has
      - credentials/identity/profile info?
    - belongsTo
      - Room
      - Message lastMessageReceived

  - Room
    - has
      - tier
      - Date created
    - hasMany
      - User members
      - Message deliveryInProgress

  - Message (maybe handled for us by message protocol?)
    - has
      - String content
      - Date sent
      - Number acksRemaining
    - belongsTo
      - User sender
      - Room destination

Services:

  - API Gateway
    - $3.50/million calls
    - $0.09/GB sent out, less after 10TB
    - Caching also available but I'm not seeing the value yet

  - Simple Queue Service
    - First 1M requests/month are free
    - $0.50 per 1M after that
    - 1 to 10 messages per request up to 256KB
    - requests > 64KB have more complex billing
    - There's also an S3 integration thing which doesn't apply to us
    - Per/GB sent similar to API gateway
      - Need to determine whether traffic between SQS and API counts against
        billing, or only traffic leaving the Amazon border

  - Simple Work Flows
    - Need to figure out if/how this fits in

  - DynamoDB
    - 
