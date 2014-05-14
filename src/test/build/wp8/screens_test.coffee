# If you choose to set `phonegap.config.screens.wp8` with one or more icon
# files, these files will be copied into the appropriate directories to use as
# your app icon.
#
# Valid icon entries for wp8 include `portrait` only.

grunt = require 'grunt'
path = require 'path'
hash_file = require 'hash_file'
helpers = require(path.join __dirname, '..', '..', '..', 'tasks', 'helpers')(grunt)

if helpers.canBuild 'wp8'

  tests = {}

  orig = path.join 'test', 'fixtures', 'www'
  wp8 = path.join 'test', 'phonegap', 'platforms', 'wp8'

  screens = [
    [ path.join(orig, 'screen-wp8-portrait.jpg'), path.join(wp8, 'SplashScreenImage.jpg') ]
  ]

  screens.forEach (pair) ->
    tests["wp8 screen #{pair[0]}"] = (test) ->
      test.expect 3
      test.ok grunt.file.isFile(pair[0]), "#{pair[0]} does not exist"
      test.ok grunt.file.isFile(pair[1]), "#{pair[1]} does not exist"
      hash_file pair[0], 'sha1', (err, src) =>
        hash_file pair[1], 'sha1', (err, dest) =>
          test.equal dest, src, "hash should match for #{pair[0]} => #{pair[1]}"
          test.done()

  exports.group = tests