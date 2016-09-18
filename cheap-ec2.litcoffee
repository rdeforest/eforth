# How to minimize AWS costs for SCC students

## Idea 1: Automatically shut down resources when not in use

This idea has three major elements:
- A way of defining "in use"
- A way of gracefully "shutting down" a student's AWS resources
- A way of gracefully "restarting" a students AWS resources

Restarting happens when a student needs it to. This could be triggered by an
API Gateway event or possibly even by the student logging in to the AWS
console.

Shutting down can happen either at the student's behest or automatically when
they "go idle".

The meaning of "in use" or "go idle" will have to be partially in the studen't
control.

### About the major elements

#### 'In use' / 'Idle'

There are three aspects of this:

- What sorts of activity indicate student activity?
- How long can an account go without activity before it is considered 'idle'?
- How does the system schedule deadman switch checks?

At the very least, shell activity on EC2 hosts should be considered activity.
Beyond that an evaluation will have to be made to decide which events are
background noise and which are tinkering. For example, it is not unusual for
an Internet-facing service to see random activity from bots looking for
services they can exploit. This should not keep a student's system online. On
the other hand, a student might get to a point in their project where all of
their activity in a given hour is just API calls.

The difficulty of this is mitigated by notifying the student before shut-down
so they can explicitly indicate that they are still using the system, but the
better the system is at knowing the right answer by default, the
closer-to-the-line the system can operate.

#### Graceful shutdown

At such time as this scheme has determined that the user is done, either
because the user has triggered a shutdown or because they failed to freshen
the various dead-man switches, the system needs to go through a graceful
shutdown.

In this case 'graceful' means a couple of things:

- restartable
- sufficient warning to allow student to cancel it

Restartable is something which will partly be defined by the restart process
which itself will be defined by the components the student spins up.

#### Startup

This will depend heavily on the student's expectations.

### Implemetation details

#### Lifecycle

At "startup", create a CloudWatch scheduled alert which triggers a deadman
switch evaluation.

Easily captured events (e.g. API calls) should update the deadman switch
status.

When the timer goes off, compare the "last update" value to the "too idle"
value. If the system is not yet too idle, schedule the next wake-up for a
little after when the system will have been too idle if nothing happens before
then.

If the idle checker wakes up and the flag is stale, a fallback check tests
metrics which are expensive to update regularly, such as the 'w | head | awk
...' thing.

If the system _still_ looks idle, send the student a notification which they
can respond to within some amount of time to abort a shutdown.

If the student doesn't respond, proceeed with shutdown.

####
