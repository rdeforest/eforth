# Combining ontology nodes

Or perhaps more accurately, applying them to each other.

## Objectives

- Ability to "program" my organization system
  - Combine orthogonal entities
    - Life Cycle + Self => Personal improvement
    - Life Cycle + Guitar => Music hobbie
    - Communication + Friends + Tools => Chat, Email, etc
- Combinations may themselves be abstract and combinable
- Combinations have
  - derived and/or specified priorities
  - zero or more
    - cycles
    - projects
    - issues
- I'd like this to all be actually programmed {-}
  - persisted
  - queryable
  - editable
  - rendered
  - dynamic
- System should be "simple" {+}
  - Low friction
  - High availability
  - Cheap
  - "Loose" / "Flexible" (not sure what I'm saying here)

# Options

## StrongLoop app

### How

- Make a StrongLoop app, run it in AWS
- Models
  - Topic
    - has
      -    1 String      name
      -    1 String      description
      - 0..1 PriorityMod priorityMod
      - 0..1 Topic       parent
      - 0..n Topic       children
      - 0..n Combination ingredientIn
      - 0..n Activity    activities
      - 0..n Issues      issues
    - does
      - getDerivedPriority
  - Combination
    - extends Topic
    - 2..n Topics as components
  - Activity
    - extends Topic
    - 1..n String 
  - Issue
    - extends Topic
  - PriorityMod
    - has
      -    1 Boolean isAbsolute
      -    1 ModType
      -    1 Number  value
  - DerivedPriority extends PriorityMod
- Interface
  - Authenticated Public web, preferably OAuth?
  - Views
    - Login
    - Dashboard
    - Topics
    - Topic
    - Combinations
    - Combination
    - Activities
    - Activity
    - Issues
    - Issue

## Trello system

## Notebook of some sort

- Moleskin?
- Index cards on a ring like Raine's study materials?

## Find an existing app

## Find an existing tool

