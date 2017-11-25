# Pass Gas - The Serious Password Manager with the Funny Name

"Whoever smelt it, dealt it."

## Purposes

(Blatently stolen from [Tim Bray](http://www.tbray.org/ongoing/When/201x/2017/07/16/On-Password-Managers))

- Store your passwords in a safe way, protected by at least a password, which we call the “master password”.

- Make new passwords for you. Here's an example of a generated password: QzbaLX}wA8Ad8awk. You're not expected to remember these.

- Make it easy to use passwords. One way is to copy it out of the manager and paste it into a password field. Another is to use a browser plugin that auto-fills login forms. On certain combinations of app and mobile device, you can use your fingerprint to open the password manager, which makes everything way faster and easier.

- Store other stuff too. I keep various Important Numbers and AWS credentials and recovery phrases and so on in there.

- Synchronize between devices. I have two computers and one phone and I need access to my passwords on all of them.

# Phases

## Phase 0: it could work...

A proof of concept which generates, stores and retrieves passwords.

## Phase 1: it works...

It will probably have to be (at least) a Chrome extension so it has the ability
to fill in forms.

## Phase 2: it's better than the alternatives

A safe has one or more persistence locations and uses Shamir's Secret Sharing
to provide added security on top of encrypting the safe itself, as well as
redundancy.

# How to develop this project

- The code is written in CoffeeScript 2 and kept in src/
- A Cakefile exists (eventually) to build the project into build/
- Unbuilt, the project can be run as an unpacked Chrome extension.

# Design

Based on the "Secret Garden" I came up with at Disney.

## Objects

All fields are UTF-8 strings or ISO dates unless otherwise specified.

Optional (nullable) fields indicated with ? after type.

- Verb
  - String name
    - "not", "allow", "member of", "contains"

- Persisted
  - Store store
  - UUID id
    - All object references are by UUID
    - A field with a type of UUID references any Persisted object

- Store
  - is abstract
    - vmethods: get, put, size?, ids?, has?

### Children of Persisted

- GardenerIdentity
  - URN      name
  - String   publicKey
    - couldbe GPG key, ssh key, or whatever
  - String?  secretKey

- Event
  - Date     time
  - Gardener owner
  - String?  description, data

- Managed
  - String   description
  - UUID     predecessor
  - Event    changed
  - Flag     deleted

### Children of Managed

- TreeOf(UUID)
  - TreeOf           subtrees[]
  - UUID             members[]

- Gardener
  - GardenerIdentity identifiers[]

- Secret
  - String           payload

- TreeOf(Secret)     SecretPlot
- TreeOf(Gardener)   GardeningTeam

- Path
  - SecretPlot       plot
  - Gate?            gate
  - Path?            next

- Lock
  - Verb             verb
  - UUID             args[]

- Gate
  - Lock             lock
  - Path             path

- Garden
  - Gate             gates[]
  - Gardeners        GardeningTeam
  - Store            stores[]

### Future objects

- SquirrelCache
  - URN              location
  - GardenerIdentity accessWithIdentity

## Components

- plug-in
 - identifies and fills in forms
- store
 - protects secrets
- shuttle
 - facilitates keeping multiple stores in sync

## Ideas

### How to expose encrypted DB publicly

Use [Shamir's Secret Sharing](https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing)
to break a protected store into pieces we're comfortable exposing to the
public Internet. Post them to multiple independent services to ensure we can
assemble the store when some portion of our locations are unreachable for some
reason. Each piece should still be gated by unique credentials to raise the
cost to an adversary of re-assembling the parts.
