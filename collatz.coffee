collatz = (n) -> if n % 2 then n * 3 + 1 else n / 2
icollatz = (n) -> (yield n = collatz n) while n > 1

module.exports = {collatz, icollatz}
