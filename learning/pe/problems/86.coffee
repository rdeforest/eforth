###

- Two right triangles
  - abc and ABC

<-a->+
     ^
     |
  c  b
     |
     v
     +<-A->+
           |
        C  B
           |
           v

- b and B are integers
- a + A is an integer
- c + C is an integer

We know one answer has

- b = 5
- B = 3
- a + A = 6
- c + C = 10
- c = sqrt(a^2 + b^2)
- C = sqrt(A^2 + B^2)
- 10 = c + C

Solving for a...

- A = 6 - a

APPARENTLY a = 15/4

 10 = sqrt(a^2 + b^2) + sqrt((6-a)^2 + B^2)
    = sqrt(a^2 + 25) + sqrt((6-a)^2 + 9) - 10


{squares} = require '../sequences'

module.exports =
  (solutionsNeeded = 2000) ->
    ...



###
