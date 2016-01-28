function Factory(module, name, methods) {
  var constructor = module[name];
  constructor.prototype = methods;

  return function newFactory() {
    var o = Object.create(constructor);
    constructor.apply(o, arguments);
