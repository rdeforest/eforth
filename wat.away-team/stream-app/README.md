# What .. what is this?!

I'm trying to create a Node module for simplifying the development of apps based on a streamed interface.

# Assumptions

In-band protocol is line-based. Out-of-band protocol starts with a negotiated binary signal and then looks like JSON. Details below.

# Binary protocol

    MARKER JSON

 * MARKER is negotiated. Default is #$# to match MCP.
 * JSON is a JSON object containing a request or response
 * There is no space between MARKER and JSON
   * for example: #$#{request:"1",ping:"hello"}
   * response:    #$#{replyto:"1",pong:"hello"}

## Request semantics

Defined top-level keys:

 * request
   * chosen by initiator, should be unique within a session to avoid ambiguity, but otherwise arbitrary
 * replyto
   * when responding to a message providing a 'request' key, the replyto will have the matching value
 * ping, pong
   * request and response keys for an echo request and reply respectively
 * more to be added later

