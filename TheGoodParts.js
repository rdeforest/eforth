Function.prototype.method = function (name, f) {
  if (!this.prototype[name]) {
    this.prototype[name] = f;
    return this;
  }
};

Function.method('new', function () {
  var that = Object.create(this.prototype);
  var other = this.apply(that, arguments);
  return (typeof other === 'object' && other)
                                    || that;
};

Function.method('inherits', function (Parent) {
  this.prototype = new Parent();
  return this;
};

Object.method('superior', function (name) {
  var that = this,
      method = that[name];

  return function () {
    return method.apply(that, arguments);
  };
};


var fog = function(f, g) {
  return function() {
    return f(g.apply(null, arguments));
  }
}

var rmap = function(x, fs) {
  var results = [], f, ret;

  while (fs) {
    f = fs.pop();
    try {
      ret = undefined;
      ret = [null, f(x)];
    } catch {
      ret = [e, ret];
    }
    results.push(ret);
  }

  return results;
}
