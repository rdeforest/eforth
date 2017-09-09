Step 1: come up with a "board game" style way of representing data models and
their schemata.

# Who wants what, why can't they have it, and why do I care?

## Who wants what

The "customer" wants
- persistence (store/retrieve)
- query (like this, but)
- frugality
- performance (low latency, high throughput)
- resiliance

The "engineer" wants
- to solve the customer's problem

## Why can't they have it

Engineering is hard?

## Why do I care

Engineering is fun?

## The problem space

Mapping data requirements to schema definitions.
Evaluating solutions along each axis of expectations.

# noodling

- kinds of data expetations
 - popular queries
 - high-priority queries
 - read/write ratios
 - daily/weekly/yearly cycles
 - downtime allowed?
 - availability
 - disaster recovery
 - traits
  - quantity
  - size
  - longevity
- relationships
 - 1:1
 - 1:n
 - n:m

- complexity problems
 - trees
  - geneology
 - arbitrary graphs
  - road system
 - N dimensional matrixes
  - affiliation x district x issue x vote distribution x ...

- scaling problems: the right solution is dependent on customer expectations
 - wharehousing: lots of data, low transaction rate, high latency tolerated
 - cacheing: short record longevity, high transaction rate, low latency required

- tool issues
 - RDBMS vs NoSQL vs GraphDB

# Normal Forms

> "[Every] non-key [attribute] must provide a fact about the key, the whole
> key, and nothing but the key." A common variation supplements this
> definition with the oath: "so help me Codd".

Requiring existence of "the key" ensures that the table is in 1NF; requiring
that non-key attributes be dependent on "the whole key" ensures 2NF; further
requiring that non-key attributes be dependent on "nothing but the key"
ensures 3NF

    Name  | Phone              | Issue
    ------+--------------------+------
    Alice | 123-4567           |
    Alice | 234-5678           | Violates 2NF: Two values in Name column
    Bill  | 123-4567           | Violates 2NF: Two values in Phone column
    Chuck | 345-6789, 135-7924 | Violates 1NF: Two values in one column

Solved by separate tables:

    Name

      id | Name
      ---+-------
       1 | Alice
       2 | Bill
       3 | Chuck

    Phone Number

      id | Phone
      ---+-------
       1 | 123-4567
       2 | 234-5678
       3 | 345-6789
       4 | 135-7924

    NameAndNumber

      id | nameId | numberId
      ---+--------+---------
       1 |      1 |        1
       2 |      1 |        2
       3 |      2 |        1
       4 |      3 |        3
       5 |      3 |        4

