// Generated by CoffeeScript 2.0.0-beta5
(function() {
  var Element, PlotFunction, Range, gnuplot, plot, set, splot;

  gnuplot = require('gnuplot');

  PlotFunction = class PlotFunction {
    constructor(info) {
      if (info instanceof PlotFunction) {
        return info;
      }
      if (this.isGenerator = info instanceof GeneratorFunction) {
        this.generator = info;
      } else {
        if (this.isFunction = 'function' === typeof info) {
          this.generator = function*() {
            var ref, results, ret, state;
            state = {};
            results = [];
            while ((ref = (ret = info(state))) !== null && ref !== (void 0)) {
              results.push((yield ret));
            }
            return results;
          };
        } else if (Array.isArray(info)) {
          this.generator = function*() {
            var e, i, len, results;
            results = [];
            for (i = 0, len = info.length; i < len; i++) {
              e = info[i];
              results.push((yield e));
            }
            return results;
          };
        } else {
          throw new Error("unsupported PlotFunction type");
        }
      }
    }

  };

  Element = class Element {
    constructor(fn, opts1 = {}) {
      this.fn = fn;
      this.opts = opts1;
      this.fn = new PlotFunction(this.fn);
    }

  };

  Range = class Range {
    constructor(...info) {
      if (info.length === 1) {
        info = info[0];
      }
      if (Array.isArray(info)) {
        [this.from, ...extra, this.to];
      } else {
        ({from: this.from, to: this.to} = info);
      }
    }

    toString() {
      return `[${this.from || ''}:${this.to || ''}]`;
    }

  };

  set = function(opts) {};

  plot = function(...elements) {
    var ranges, results;
    ranges = [];
    results = [];
    while (!(elements[0] instanceof Element)) {
      results.push(ranges.push(elements.shift()));
    }
    return results;
  };

  splot = function(...elements) {
    var ranges, results;
    ranges = [];
    results = [];
    while (!(elements[0] instanceof Element)) {
      results.push(ranges.push(elements.shift()));
    }
    return results;
  };

  Object.assign(exports, {Element, Range}, {
    dsl: {set, plot, splot}
  });

  exports.plot = function(ranges, fns, opts = {}) {
    if ('function' === typeof ranges[0]) {
      [ranges, fns, opts = {}] = [[], ranges, fns];
    }
    ranges = ranges.map(function(r) {
      return new Range(r);
    });
    return fns = fns.map(function(f) {
      return new Element(f);
    });
  };

}).call(this);
