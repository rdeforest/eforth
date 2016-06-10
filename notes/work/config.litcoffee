# A general solution to configuration management

## Problems

### Exceptions are the norm

Describing configurations is easiest when expressed in terms of exceptions.
Severity is usually 3, except in production where it's usually 2, except in
stacks that are administratively offline in which case it's 5 and related to
the ticket which took the stack offline or stacks that are being built in
which case a ticket shouldn't be cut at all.

... except in Payments or China. Everything is different in Payments and
China.

The impact of making a change in a system with this much inter-dependence may
not be obvious. Certainly the system can diff the resulting configs, but a
human would be no better at verifying that then they would be at manually
generating it.

## Solutions

 - Monitoring should require approval for big changes?

 - Don't deploy config changes unless they are expected to clear monitors?


