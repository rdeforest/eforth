# RDF: Required Damn Features

Name is a work in progress.

# Mission

# Features

## Extending Boxed Types

- String
 - "foo bar".qw returns ['foo', 'bar']
- Array
 - Remembers whether it has been mutated since it was the result of a sort
  - adds 'insertSorted' and 'deleteSorted'
  - default sort is default of Array.sort()
  - can be overriden by setting .sortWith to a comparator function

## Standard libraries

- ramda
- debug

## Private data

See (require 'lib/private').Private.comment for details.

## Progress reporting to console or other stream

```coffee

{ Progress } = require 'lib/progress'
progress = new Progress
  maxDelay: 10000,
  minDelay:  1000,
  writer: console.log

for record, n from iterator()
  progress.update "count: #{n + 1}, current: #{record.id}"
  # do something with record

powers = (exponent) ->
  n = 1

  loop
    yield n
    n *= exponent

```

This will write the current count and record id to the console no more than 10
seconds after the last update and no sooner than 1 second after the last
update. If record N takes 2^N milliseconds to process and has that id as well,
then output would look something like:

    count: 1, current: 2
    count: 9, current: 512
    count: 11, current: 2048
    count: 12, current: 4096
    count: 13, current: 8192
    count: 14, current: 16384
    count: 14, current: 16384
    count: 15, current: 32768
    count: 15, current: 32768
    count: 15, current: 32768

etc.

## Identified objects

## Table manipulation and rendering

## Sane defaults

- setup-testing
