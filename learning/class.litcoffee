- global.Function
  - is a function
  - constructs Functions

- global.Object
  - is a function
  - constructs Objects

- class Foo
  - is a function
  - constructs Foos

- Foo.bar  is like (new Foo).contructor.bar when .bar is defined on Foo
-          or else (gp Foo).bar
-    which is also (Function::)['bar']
- Foo::bar is      (new Foo).bar

Foo.prototype is Object.getPrototypeOf new Foo
