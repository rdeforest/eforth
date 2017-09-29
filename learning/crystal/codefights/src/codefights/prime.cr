# Bit of monkey-patching to handle shifting contents
struct BitArray
  def shift(other : BitArray, shift : Int)
    ba = BitArray.new()
  end
end

module Codefights
  SIEVE_LENGTH = 1024

  sieve        = BitArray.new(SIEVE_LENGTH)
  sieveOffset  = 0
  sieveEnd     = 0

  primes       = [ 2, 3, 5, 7, 11 ]
  lastPrime    = primes[-1]

  def initSieve
    if sieveOffset
      return reinitSieve
    end

    sieveEnd = (sieveOffset = primes[-1] + 2) + SIEVE_LENGTH * 2

    i = 1
    while i < primes.length
      p = primes[i++]
      q = lastPrime - lastPrime % p

      while (q += p) < sieveEnd
        sieve[(q - sieveOffset - 1) / 2] = true
      end
    end
  end

  def reinitSieve
    shift = (newSieveOffeset = primes[-1] + 2) - sieveOffset
    newSieve = BitArray.new(SIEVE_LENGTH)

  end

  def nextPrime
    initSieve
  end

  def primeTest(n)
    i = 0

    while i < primes.length
      if 0 == n % primes[i]
        return false

      i++
    end

    loop do
      p = nextPrime

      if (2p = p * p) > n
        return true

      if 2p == n || 0 == n % p
        return false
    end

    return true
  end
end

struct Number
  def isPrime
    case self
    when .< 2
      nil
    when 2, 3, 5, 7, 11
      true
    else
      Codefights::primeTest self
    end
  end
end

