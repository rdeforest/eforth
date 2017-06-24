#!/usr/bin/nodejs

var fs = require('fs');
var repl = require('repl');
var Tail = require('tail').Tail;

function deriveConfig(argv) {
  // ...
  return {
    paths: [ "." ],
  };
}

var config = deriveConfig(process.argv);
var following = {};
var lastSeen = undefined;

function spewLatest(fileName, chunk) {
  if (lastSeen != fileName) {
    console.log("\n\n--- ", fileName);
  }

  lastSeen = fileName;
  console.log(chunk.toString());
}

function tailFile(fileName) {
  var reader = new Tail(fileName);

  reader.on('line', function(data) {
      spewLatest(fileName, data);
    });

  return reader;
}

function followFile(fileName) {
  if (!following[fileName]) {
    console.log("New listener: ", fileName);
    following[fileName] = tailFile(fileName);
  }
}

function followDir(dirName) {
  // may not be necessary since we have recursion on...
}

function followPath(path) {
  try {
    var stat = fs.statSync(path);
  } catch (e) {
    if (e.code != 'ENOENT') {
      console.log("Error statting ", path, ": ", e);
    }
    return;
  }

  if (stat.isFile) {
    followFile(path);
  } else if (stat.isDir) {
    followDir(path);
  } else {
    console.warn("Don't know how to follow '", path, "'.");
  }
}

function makeListener(dir) {
  return function (e, path) {
    followPath(dir + "/" + path);
  }
}

for (var i = 0; i < config.paths.length; i++) {
  var p = config.paths[i];

  console.log("Watching ", p);
  fs.watch(p, {persistent: true, recursive: true}, makeListener(p));
}

var replCons = repl.start({}).context.following = following;
