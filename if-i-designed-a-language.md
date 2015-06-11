# Functions

Definition

    fname(argspec) := { code }

    fname(args, ...) := {
      code
    }

Default arg vals

    fname(foo | 'foo default') := { code }

'rest' args

    fname(x, y, @etc) := { code }

Lambdas

    (args) := { code }

For example

    someArray.forEach((e) := { console.log(e) }

# Objects and Arrays

Same as CoffeeScript.

# Variables

Same as CoffeeScript: lexical by default

# flow control

Keep classic C syntax

    if (expr) { code } else { code }

    for (init; cond; iter) { code }

    while (cond) { code }

Also adopt the modern constructions

    barTender.refill(glass) if glass.empty

    glass.takeDrink unless chaparone.canSee(me)

    do { code } while (cond)

    foreach varName (iterator) { code }

No "unless" or "until". They're too lazy even for me. What's wrong with while (!cond)?

No need for 'switch' because of functional programming.

    switch(expr, cases) := {
      fallthrough = false
      
      foreach (cases)
