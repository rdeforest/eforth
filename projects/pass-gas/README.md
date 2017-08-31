# Pass Gas - The Password Manager with the Funny Name

"Whoever smelt it, dealt it."

## Purposes

(Blatently stolen from [Tim Bray](http://www.tbray.org/ongoing/When/201x/2017/07/16/On-Password-Managers))

- Store your passwords in a safe way, protected by at least a password, which we call the “master password”.

- Make new passwords for you. Here’s an example of a generated password: QzbaLX}wA8Ad8awk. You’re not expected to remember these.

- Make it easy to use passwords. One way is to copy it out of the manager and paste it into a password field. Another is to use a browser plugin that auto-fills login forms. On certain combinations of app and mobile device, you can use your fingerprint to open the password manager, which makes everything way faster and easier.

- Store other stuff too. I keep various Important Numbers and AWS credentials and recovery phrases and so on in there.

- Synchronize between devices. I have two computers and one phone and I need access to my passwords on all of them.

# Phases

## Phase 0: it could work...

A proof of concept which generates, stores and retrieves passwords.

## Phase 1: it works...

It will probably have to be (at least) a Chrome plug-in so it has the ability
to fill in forms.

# How to develop this project

- The code is written in CoffeeScript 2.0 and kept in src/
- A Cakefile exists (eventually) to build the project into build/
- Unbuilt, the project can be run in the usual way (DEBUG=pass-gas:server ./bin/www)

