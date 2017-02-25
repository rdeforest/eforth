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

