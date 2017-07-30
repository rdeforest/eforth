# wat

## the good

- I like the elegance of Lisp's syntax.
- I like that Lisp operates on itself. It's the ultimate in dogfooding.

## the bad

- Lisp syntax is oddly verbose for how light it is
 - adding meaning to more tokens could help?
 - significant whitespace (CoffeeScript) could help?

# so...

## The syntax options

### RPN

```forth
    : max       ( a b -- c )
      over over ( a b a b )
      - 0 < if swap then ( max lesser )
      drop
    ;
```

### Prefix kinda

```

    : max 

```
