function Example(args) {
  this.data = args;
}


require('factory')(this,
  'Example',
  {
    method: function () { console.log(this) },
  }
);
