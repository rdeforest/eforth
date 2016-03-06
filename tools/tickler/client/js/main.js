/*global require*/
'use strict';

// Require.js allows us to configure shortcut alias
require.config({
  // The shim config allows us to configure dependencies for
  // scripts that do not call define() to register a module
  shim: {
    underscore: {
      exports: '_'
    },
    backbone: {
      deps: [
        'underscore',
        'jquery'
      ],
      exports: 'Backbone'
    },
    backboneLocalstorage: {
      deps: ['backbone'],
      exports: 'Store'
    }
  },
  paths: {
    jquery: '../node_modules/jquery/dist/jquery',
    "jquery-ui": '../node_modules/jquery-ui/jquery-ui',
    underscore: '../node_modules/underscore/underscore',
    backbone: '../node_modules/backbone/backbone',
    backboneLocalstorage: '../node_modules/backbone.localstorage/backbone.localStorage',
    text: '../node_modules/requirejs-text/text',
    cs: '../node_modules/require-cs/cs',
    "coffee-script": '../node_modules/coffee-script/lib/coffee-script/coffee-script'
  }
});

require([
  'backbone',
  'views/app',
  'routers/router',
  'connect',
  'jquery-ui'
], function (Backbone, AppView, Workspace, connect) {
  /*jshint nonew:false*/
  // Initialize routing and start Backbone.history()
  new Workspace();
  Backbone.history.start();

  // Initialize the application view
  new AppView();

  $("#todoapp").tabs();
  $("#login")
    .button()
    .click(function(e) {
      console.log("Todo: login button");
    });
  $("#register")
    .button()
    .click(function(e) {
      console.log("Todo: register button");
    });

  // console.log("Connect: ", connect);
});
