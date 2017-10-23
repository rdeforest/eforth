# Fixing the world, as usual

It seems the Joe test framework has no documentation for its reporter API. So
I'm going to both document it and also make a framework for it.

Events:

- startSuite:  suite
- finishSuite: suite, err
- startTest:   test
- finishTest:  test, err
- exit:        exitCode, reason

When these events happen, if the reporter's property of the event name is
defined, it is invoked with the args after the colons above. Args other than
exitCode and reason are objects.

# Identified

## ::[eventName](args..)

