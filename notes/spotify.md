# Spotify's queue management is dumb

  - "next" vs "queue" distinction doesn't make sense
  - Playing a set of songs makes the first in the set current but appends the
    rest to "next" or something (it's still not quiet clear to me what's going
    on)
  - Current queue obliteration can only be accomplished by playing the last song

# What I would do

  - Treat a song and a song list (playlist, station, album, etc) the same
  - Make all queue management possible, easy and explicit
    - clear queue
    - save queue to play list
    - order by X
    - scramble
    - queue operations on items (remove, copy, re-position)
    - queue operations on selections (remove, copy, re-order, re-position)
  - Operations on items and lists outside of queue view
    - "play now", "play next" and "play later"

## About item tagging

  - Tags are parametric
    - strings:
      - "is identified on album as X" ("Whole Lotta Love")
    - scalars: "on scale X, has value Y"
      - X is a number given meaning by Y
      - Y is a defined scale which has 
        - a range
        - type (linear, log, etc) 
        - origin 
          - sheet music/artist for BPM
          - magazine/site/etc for rating
      - example
        - "track (1) on album (Led Zeppelin II)"
    - reference: "related to X"
      - "contains lyrics in language X" 
        - X is a reference to "English", "French", etc
      - "Parody/cover of X"
      - "Theme/sound track from X"
  - All entities have tags
    - track, artists, albums, publishers, genres, users, communities, ...
    - Item type is a tag
      - Tags have referential tag "is of type X" with parameter "tag"
    - Artist information on songs are captured in tags
      - "performed by X"
      - "written by X"
      - "created by X"
      - example:
        - Written by Willie Dixon
        - Amended by (Bonham, Jones, Page, Plant)
        - Performed by Led Zeppelin
  - A given class has required and preferred tags
    - tracks require
      - album
      - track number
    - tracks prefer
      - name
      - duration
      - bpm
  - Only difference between "concrete" information (like name, artist and running
    length) and what people normally think of as tags is their origin

## Auto-play feature: interface via which users can develop their own DJ algorithms

  - finding songs by
    - GUID
    - concrete things
      - name
      - artist, album, running length, slowest/typical/fastest beats per minute
      - release information: when, publisher, etc
      - quasi-objective tagging
        - live, remastered, explicit, (un)censored, ...
        - language, culture, ...
        - style: orchestral, accoustic
        - instruments used
    - tags
      - tags applied by specified sets of users
        - 'me'
        - 'my friends'
        - 'Spotify users who listen more than two hours a day'
        - ...
      - tags publishers apply to items in their own libraries
      - tags artists apply to their own works

