/*

We define the weakness of number x as the number of positive integers smaller
than x that have more divisors than x.

It follows that the weaker the number, the greater overall weakness it has.
For the given integer n, you need to answer two questions:

  what is the weakness of the weakest numbers in the range [1, n]?
  how many numbers in the range [1, n] have this weakness?

Return the answer as an array of two elements, where the first element is the
answer to the first question, and the second element is the answer to the
second question.
 */

(function() {
  var divides, divisors, memo, numDivisors, strongerThan, weakest, weakness;

  memo = function(fn, keyFn = function(n) {
      return n;
    }) {
    var stored;
    stored = {};
    return function(...args) {
      var name;
      return stored[name = keyFn(...args)] != null ? stored[name] : stored[name] = fn(...args);
    };
  };

  divides = memo((function(n, m) {
    return 0 === n % m;
  }), (function(n, m) {
    return `${n}:${m}`;
  }));

  divisors = memo(function(n) {
    var i, results;
    return (function() {
      results = [];
      for (var i = 1; 1 <= n ? i <= n : i >= n; 1 <= n ? i++ : i--){ results.push(i); }
      return results;
    }).apply(this).filter(function(m) {
      return n % m === 0;
    });
  });

  numDivisors = function(n) {
    return divisors(n).length;
  };

  strongerThan = memo(function(n) {
    var i, ownDivisors, ref, results;
    if (n < 2) {
      return 0;
    }
    ownDivisors = numDivisors(n);
    return (function() {
      results = [];
      for (var i = 1, ref = n - 1; 1 <= ref ? i <= ref : i >= ref; 1 <= ref ? i++ : i--){ results.push(i); }
      return results;
    }).apply(this).filter(function(m) {
      return numDivisors(m) > ownDivisors;
    });
  });

  weakness = function(n) {
    if (n < 2) {
      return 0;
    }
    return strongerThan(n).length;
  };

  weakest = memo(function(n) {
    var i, m, ref, w, winner;
    winner = [0, 0];
    for (m = i = 1, ref = n; 1 <= ref ? i <= ref : i >= ref; m = 1 <= ref ? ++i : --i) {
      if ((w = weakness(m)) > winner[0]) {
        winner = [w, 1];
      } else if (w === winner[0]) {
        winner[1]++;
      }
    }
    return winner;
  });

  module.exports = {
    strongerThan: strongerThan,
    divisors: divisors,
    weakness: weakness,
    weakest: weakest,
    numDivisors: numDivisors,
    divides: divides
  };

}).call(this);
