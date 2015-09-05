Primes = require './prime'

#Primes.makeMore 100
#console.log Primes.known

gen = Primes.generator()

console.log gen.next() for [1..10]
