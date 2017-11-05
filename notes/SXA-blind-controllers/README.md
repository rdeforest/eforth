What if Six Arms had automatic shade controls which responded to the
ever-changing Seattle light?

Use cases:

- Sun comes out and it's so bright every blind needs to be down
- Sun comes out, but it's winter so only the windows allowing blinding rays in
  need to be shuttered.
- Sun is gone, raise the blinds!

And most importantly:

- Big-wigs in town, time to show off? :)

# And how are you going to do this?

## Blind actuators

Each blind will have a small DC motor and a Raspberry Pi mounted at the top of
the window where it won't be visible and won't interfere with manual operation
(this project MUST NOT impair current functionality). These actuator modules
will be connected via a thin, well-hidden cable to power-supplies hidden in
the dividers between booths or something. The power supply needs to put out
5V/2.5A for the Raspberry Pi and probably something like 24V, 1A for the motor
which will drive the blind control shaft.

The control shaft and motor are connected via a tensioned chain. The shaft gets
some sort of gear attached to it to facilitate this.

## Sensors

- manual override
- exposure

## Control

- Each unit will connect to the McMenamins network and
 - negotiate who serves the UI
 - negotiate who controls persistence
 - update router to update
  - DNS
  - config server
  - etc

- Website (http://sixarms/blinds)
 - Authenticated against SXA administration's chosen authz/authn infrastructure
 - Access levels
  - admin
   - policy, permissions
  - staff
   - sensible overrides within policy constraints
   - read-only 
  - guest
   - read-only access (why is the blind down/up?)
   - feedback (blind should be lower/higher)

- Actuators
 - queries
  - current light
  - configured location
  - blind height
  - movement state (in motion up/down vs stopped)
 - operations
  - request notification (event, callback)
   - blind location
   - light value
   - config change
   - state change (moving, not moving, power level/change)

