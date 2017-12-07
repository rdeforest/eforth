# Goals

## Top

- All wi-fi functional and reliable in entire establishment
 - Currently

## Other

- clean, tidy, etc
- Risks managed
 - backups (maybe already fine)
 - physical security
  - Do you really want your computer unlocked in an unlocked room?
  - Staff could mess with stuff?
- Performance
 - May not be a problem
 - Route to 8.8.8.8
  - 10 hops
  - 13 to 100 ms latency
  - no packet loss
- manageability
 - May not be a problem

# Devices

## Computer 1

- Some kind of NCR
- Located on third shelf
- Probably Not Relevant Unless They Want To Expand Scope (NRUTWTES)

## Modem 1

- USRobotics Courier (probably?)
- On top of Computer, near front
- NRUTWTES

## Switch 1

- TP-Link
- 8 ports
 - 5 in use
 - 4 have link light
- On top of Computer
 - behind modem

## Switch 2

- Netgear
- 4 ports
 - one white, 3 black, all in use
- On top of Computer
 - left of modem

## Cable box

- Arris TM722
- Looks like just one 75ohm coax connection and power

## Cable 'modem'

- Cisco "Comcas Business"
- connections
 - One 75ohm coax
 - 3 ethernet ports in use

## UPS (probably)

- Unable to determine brand or model
 - but no USB or DB9 connectors so who cares
- 4/4 outlets in use
- Warm to the touch, but not too much

## hotspot 1

- Meraki Mini V2
- Found on shelf 2 left of post
 - but it's loose and light
 - could wander the lengths of its cords

# Ethernet Cables

- Yellow cable
 - from lower left port of Comcast
 - to white port of Netgear

- Light gray cable
 - from upper left port of Comcast
 - to only port of Meraki

- Thin gray cable
 - from upper right port of Comcast
 - to somewhere in the direction of the computer monitor

- Three black cables
 - from Netgear
 - to
  - printer
  - computer
  - device mounted on far wall, probably video surveilance

- Gray cable
 - from computer
 - to TP-Link

- Four black cables
 - from TP-Link
 - to Patch panel

# Config

- Canterbury wifi
 - gateway: 10.1.10.1

# Questions

- Where is the "Canterbury" hotspot?

# Proposals

## Minimum

- Just remove Canterbury-Guest
- Try to fix it

## Cleanup

- 


