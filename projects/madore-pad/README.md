# Madore Pad Protocol Server

A service for facilitating use of David Madore's free-speech-fostering
protocol suggestion.

# Features

## Server

- Anonymous users can
  - fetch the web client
  - request a list of pads
  - request a specific pad
- Authenticated users can
  - post a pad
  - edit their profile (visibility, email, auth)
  - 'delete' themselves (marks them as deleted but leaves them in the db)
  - browse public profiles
- Admin users can
  - manage users
  - manage quotas

And maybe some day

- Power users can
  - federate servers so they pass pads around randomly

## Client

In addition to the above, the client provides these features:

- create pad sets from cleartext
- create random pads
- assemble cleartext from pad sets

# Implications

I'm pretty sure as long as I don't persist logs of user activity this service
doesn't compromise David's original proposal's mechanism. "Pretty sure" isn't
good enough, so I'll have dive into this further at some point.


