//;###
// ==UserScript==
// @name         CoffeeTest
// @namespace    http://defore.st
// @version      0.1
// @description  From https://gist.github.com/saihoooooooo/3447066
// @author       guitar.robot@gmail.com
// @match        *://*/*
// @grant        none
// @require      http://code.jquery.com/jquery-2.1.4.min.js
// @require      http://coffeescript.org/extras/coffee-script.js
// ==/UserScript==

eval(CoffeeScript.compile((function(){/**
# Start of CoffeScript

@$ = jQuery.noConflict()

# console.log $.fn.jquery

# End of CoffeeScript
**/}).toString().split('\n').slice(1, -1).join('\n')));
