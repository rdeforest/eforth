var memos = {
  repeatStr: {},
};

module.exports = { 
  props: function (o) {
    return Object.getOwnPropertyNames(o);
  },

  repeatStr: function (s, n) {
    var mem = memos.repeatStr[s] || {};

    if (mem && mem[n]) return mem[n];

         if (n > 2) mem[n] = this.repeatStr(s, Math.floor(n/2)) + 
                             this.repeatStr(s, Math.ceil(n/2));
    else if (n > 1) mem[n] = s + s;
    else if (n > 0) mem[n] = s;
    else return "";

    memos.repeatStr = mem;
    return mem[n];
  },

  addTo: function (t, force) {
    var collisions = [];

    if (!force) {
      this.props(this).forEach(function (p) {
        if (Object.hasOwnProperty(t, p)) {
          if (!force) {
            collisions.push(p);
          }
        }
      });

      if (collisions) {
        throw new Error("Namespace collision(s): " + collisions.join(", "));
      }
    }

    this.props(this).forEach(function (p) {
      t[p] = this[p];
    });
  },
};
