# Based on http://www.paulgraham.com/rootsoflisp.html

# Syntactic elements

NIL = []        # '()
T = Symbol 'T'  # T

dictionary = {}

defun = (name, args, def) ->
  if 'string' is typeof name
    name = Symbol name

  if 'symbol' isnt typeof name
    throw new Error ""

  dictionary[name] = [args, def]

eval = (sexpr) ->
  [name, args...] = sexpr

  if 'function' is typeof name
    name args...

  if not dictionary.hasOwnProperty name
    throw new Error "not a function or defined symbol: #{name}"

  dictionary[name] args...

  
dictionary[sexpr[0]] sexpr[1..]...

# The seven primitives

eq = (x, xs...) ->
   if xs.length
     x is xs[0] and eq xs...
   else
     T

nullDot = (x) -> x is NIL

atom = (x) -> if x?.constructor is Array then NIL else T

car = (l) -> if atom l then NIL else l[0]

cdr = (l) -> if atom l then NIL else l[1..]

quote = (l) -> l

cons = (x, xs) -> [x, xs]

cond = (conds) ->
  if atom conds or (not conds.length) or atom conds[0]
    return NIL

  [[pred, result], conds] = conds

  if EVAL pred
    eval result
  else
    cond conds

# Now http://ep.yimg.com/ty/cdn/paulgraham/jmc.lisp
# except we use _ instead of '.' when a symbol conflicts with JavaScript or
# CoffeeScript stuff.
null_ = (x) -> ] and not x.car and not x.cdr

and_ = (x, y) ->
  cond [
    [x, cond [y, T],
             [T, NIL]
    ],
    [T, NIL]
  ]

not_ = (x) -> cond [[x, NIL], [T, T]]

append = (x, y) ->
  cond [[nullDot(x), y], [T, [cons(car(x), appendDot cdr(x), y]]

list = (x, y) -> [cons x, [cons y, NIL]]

pair = (x, y) ->
  [cond [
    [andDot [[nullDot x], [nullDot y]], NIL],
    [andDot [[notDot x], []],
    [],
  ]]

subst = (x, y, z) ->
  if atom z
    if z is y
      x
    else
      z
  else
    subst x, y, z[0]
      .concat subst x, y, z[1..]

subst = (x, y, z) ->
  return x if z is y

  z.map (e) -> subst x, y, e

assoc_ = [defun 'assoc_', ['x', 'y'],
  cond [eq [caar y] x] [cadar y]], [T, [assoc_ x, cdr y]]

###

; The Lisp defined in McCarthy's 1960 paper, translated into CL.
; Assumes only quote, atom, eq, cons, car, cdr, cond.
; Bug reports to lispcode@paulgraham.com.

(defun null. (x)
  (eq x '()))

(defun and. (x y)
  (cond (x (cond (y 't) ('t '())))
        ('t '())))

(defun not. (x)
  (cond (x '())
        ('t 't)))

(defun append. (x y)
  (cond ((null. x) y)
        ('t (cons (car x) (append. (cdr x) y)))))

(defun list. (x y)
  (cons x (cons y '())))

(defun pair. (x y)
  (cond ((and. (null. x) (null. y)) '())
        ((and. (not. (atom x)) (not. (atom y)))
         (cons (list. (car x) (car y))
               (pair. (cdr x) (cdr y))))))

(defun assoc. (x y)
  (cond ((eq (caar y) x) (cadar y))
        ('t (assoc. x (cdr y)))))

(defun eval. (e a)
  (cond
    ((atom e) (assoc. e a))
    ((atom (car e))
     (cond
       ((eq (car e) 'quote) (cadr e))
       ((eq (car e) 'atom)  (atom   (eval. (cadr e) a)))
       ((eq (car e) 'eq)    (eq     (eval. (cadr e) a)
                                    (eval. (caddr e) a)))
       ((eq (car e) 'car)   (car    (eval. (cadr e) a)))
       ((eq (car e) 'cdr)   (cdr    (eval. (cadr e) a)))
       ((eq (car e) 'cons)  (cons   (eval. (cadr e) a)
                                    (eval. (caddr e) a)))
       ((eq (car e) 'cond)  (evcon. (cdr e) a))
       ('t (eval. (cons (assoc. (car e) a)
                        (cdr e))
                  a))))
    ((eq (caar e) 'label)
     (eval. (cons (caddar e) (cdr e))
            (cons (list. (cadar e) (car e)) a)))
    ((eq (caar e) 'lambda)
     (eval. (caddar e)
            (append. (pair. (cadar e) (evlis. (cdr e) a))
                     a)))))

(defun evcon. (c a)
  (cond ((eval. (caar c) a)
         (eval. (cadar c) a))
        ('t (evcon. (cdr c) a))))

(defun evlis. (m a)
  (cond ((null. m) '())
        ('t (cons (eval.  (car m) a)
                  (evlis. (cdr m) a)))))



Lisp

(foo (bar a b c))
(foo '(bar a b c))

Coffee

foo bar a, b, c

foo sexpr ["bar", "a", "b", "c"].map strToSymbol


###
