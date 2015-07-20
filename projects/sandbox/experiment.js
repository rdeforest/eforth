#!/usr/bin/node

module.exports = (function() {
  var vm = require('vm');

  var copyObject = function (o) {
    var that = {};
    var key;

    for (key in o) {
      that[key] = o[key];
    }
  }

  var ourGlobal = copyObject(global);

  var sent, sending = {};

  var outside = {
    send: function (data) {
      sent = data;
    },
    receive: function () {
      return sending;
    },
  };

  var sandbox = vm.createContext(
    {
      outside: outside
    }
  );

  var ourEval = function (code) {
    vm.runInNewContext(code, sandbox, {filename: "sandbox", displayErrors: true});
    return sent;
  };

  var ourSend = function (data) {
    sending = data;
  };

  return {
    eval: ourEval,
    send: ourSend,
  };
})();

