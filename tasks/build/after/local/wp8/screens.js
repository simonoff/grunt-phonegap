(function() {
  var path, screens;

  path = require('path');

  module.exports = screens = function(grunt) {
    var helpers;
    helpers = require('../../../../helpers')(grunt);
    return {
      build: function(fn) {
        var phonegapPath, res, _ref;
        screens = helpers.config('screens');
        phonegapPath = helpers.config('path');
        res = path.join(phonegapPath, 'platforms', 'wp8');
        if (screens != null ? (_ref = screens.wp8) != null ? _ref.portrait : void 0 : void 0) {
          grunt.file.copy(screens.wp8.portrait, path.join(res, 'SplashScreenImage.jpg'), {
            encoding: null
          });
        }
        if (fn) {
          return fn();
        }
      }
    };
  };

}).call(this);
