# Grunt: Phonegap
> A [Grunt](http://gruntjs.com/) plugin to provide build tasks for [Phonegap](http://phonegap.com/) applications

[![Build Status](http://ci.ldk.io/logankoester/grunt-phonegap/badge)](http://ci.ldk.io/logankoester/grunt-phonegap/)
[![Dependency Status](https://david-dm.org/logankoester/grunt-phonegap.png)](https://david-dm.org/logankoester/grunt-phonegap)
[![devDependency Status](https://david-dm.org/logankoester/grunt-phonegap/dev-status.png)](https://david-dm.org/logankoester/grunt-phonegap#info=devDependencies)
[![Gittip](http://img.shields.io/gittip/logankoester.png)](https://www.gittip.com/logankoester/)

[![NPM](https://nodei.co/npm/grunt-phonegap.png?downloads=true)](https://nodei.co/npm/grunt-phonegap/)

`grunt-phonegap` integrates Phonegap development with [Grunt](http://gruntjs.com/)-based workflows
by wrapping the Phonegap 3.0 command line interface.

Rather than polluting the top-level of your project, `grunt-phonegap` copies your files into a
subdirectory containing the Phonegap project, which gets regenerated every time the task `phonegap:build` is executed.

## Jump to Section

* [Requirements](#requirements)
* [Getting Started](#getting-started)
* [Overview](#overview)
* [Dynamic config.xml](#dynamic-config.xml)
* [App Icons](#app-icons)
* [versionCode](#versioncode)
* [Android Debugging](#android-debugging)
* [minSdkVersion and targetSdkVersion](#minsdkversion-and-targetsdkversion)
* [Android Permissions](#android-permissions)
* [Android Screen Orientation](#android-screen-orientation)
* [Application Name](#application-name)
* [Phonegap Build](#phonegap-build)
* [Tasks](#tasks)
* [Running the test suite](#running-the-test-suite)
* [Contributing](#contributing)
* [Release History](#release-history)
* [License](#license)

## Requirements
[[Back To Top]](#grunt-phonegap)

You will need the `phonegap` CLI tool installed globally to use `grunt-phonegap`.

```shell
npm install phonegap -g
```
You should also install whatever system dependencies are required by the platforms
you intend to target.

For help with that, see [Platform Guides](http://docs.phonegap.com/en/3.1.0/guide_platforms_index.md.html#Platform%20Guides) from the Phonegap documentation.



## Getting Started
[[Back To Top]](#grunt-phonegap)

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

![Demo](https://cloud.githubusercontent.com/assets/19319/3005347/d911f6c6-ddda-11e3-9c87-679ca82b5499.gif)

### For new apps

The easiest way to start a new project is with the [grunt-init-phonegap](https://github.com/logankoester/grunt-init-phonegap) template.

It will ask you some basic questions and then generate a project skeleton in your current directory.

```shell
git clone https://github.com/logankoester/grunt-init-phonegap.git ~/.grunt-init/phonegap
mkdir myapp
cd myapp
grunt-init phonegap
```
Once the skeleton has generated, open up your new `Gruntfile.coffee` add one or more platforms to the list.

Your app is ready to build! [[Skip to Tasks]](#tasks) to see how.

### For existing apps

```shell
npm install grunt-phonegap --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-phonegap');
```



## Overview
[[Back To Top]](#grunt-phonegap)

In your project's Gruntfile, add a section named `phonegap` to the data object passed into `grunt.initConfig()`.

Point `phonegap.config.root` to the output of your other build steps (where your `index.html` file is located).

Point `phonegap.config.config` to your [config.xml](http://docs.phonegap.com/en/3.0.0/config_ref_index.md.html) file.

`phonegap.config.cordova` should be the `.cordova` directory that is generated by `phonegap create`. It must
contain a `config.json` file or your app cannot be built.

### Options

```js
grunt.initConfig({
  phonegap: {
    config: {
      root: 'www',
      config: 'www/config.xml',
      cordova: '.cordova',
      html : 'index.html', // (Optional) You may change this to any other.html
      path: 'phonegap',
      cleanBeforeBuild: true // when false the build path doesn't get regenerated
      plugins: ['/local/path/to/plugin', 'http://example.com/path/to/plugin.git'],
      platforms: ['android'],
      maxBuffer: 200, // You may need to raise this for iOS.
      verbose: false,
      releases: 'releases',
      releaseName: function(){
        var pkg = grunt.file.readJSON('package.json');
        return(pkg.name + '-' + pkg.version);
      },
      debuggable: false,

      // Must be set for ios to work.
      // Should return the app name.
      name: function(){
        var pkg = grunt.file.readJSON('package.json');
        return pkg.name;
      },

      // Add a key if you plan to use the `release:android` task
      // See http://developer.android.com/tools/publishing/app-signing.html
      key: {
        store: 'release.keystore',
        alias: 'release',
        aliasPassword: function(){
          // Prompt, read an environment variable, or just embed as a string literal
          return('');
        },
        storePassword: function(){
          // Prompt, read an environment variable, or just embed as a string literal
          return('');
        }
      },

      // Set an app icon at various sizes (optional)
      icons: {
        android: {
          ldpi: 'icon-36-ldpi.png',
          mdpi: 'icon-48-mdpi.png',
          hdpi: 'icon-72-hdpi.png',
          xhdpi: 'icon-96-xhdpi.png'
        },
        wp8: {
          app: 'icon-62-tile.png',
          tile: 'icon-173-tile.png'
        },
        ios: {
          icon29: 'icon29.png',
          icon29x2: 'icon29x2.png',
          icon40: 'icon40.png',
          icon40x2: 'icon40x2.png',
          icon50: 'icon50.png',
          icon50x2: 'icon50x2.png',
          icon57: 'icon57.png',
          icon57x2: 'icon57x2.png',
          icon60: 'icon60.png',
          icon60x2: 'icon60x2.png',
          icon60x3: 'icon60x3.png',
          icon72: 'icon72.png',
          icon72x2: 'icon72x2.png',
          icon76: 'icon76.png',
          icon76x2: 'icon76x2.png'
        }
      },

      // Set a splash screen at various sizes (optional)
      // Only works for Android and IOS
      screens: {
        android: {
          ldpi: 'screen-ldpi-portrait.png',
          // landscape version
          ldpiLand: 'screen-ldpi-landscape.png',
          mdpi: 'screen-mdpi-portrait.png',
          // landscape version
          mdpiLand: 'screen-mdpi-landscape.png',
          hdpi: 'screen-hdpi-portrait.png',
          // landscape version
          hdpiLand: 'screen-hdpi-landscape.png',
          xhdpi: 'screen-xhdpi-portrait.png',
          // landscape version
          xhdpiLand: 'www/screen-xhdpi-landscape.png'
        },
        ios: {
          // ipad landscape
          ipadLand: 'screen-ipad-landscape.png',
          ipadLandx2: 'screen-ipad-landscape-2x.png',
          // ipad portrait
          ipadPortrait: 'screen-ipad-portrait.png',
          ipadPortraitx2: 'screen-ipad-portrait-2x.png',
          // iphone portrait
          iphonePortrait: 'screen-iphone-portrait.png',
          iphonePortraitx2: 'screen-iphone-portrait-2x.png',
          iphone568hx2: 'screen-iphone-568h-2x.png',
          iphone667hx2: 'splash-iphone-667h-2x.png',
          iphone736hx3: 'splash-iphone-736h-3x.png'
        }
      },

      // Android-only integer version to increase with each release.
      // See http://developer.android.com/tools/publishing/versioning.html
      versionCode: function(){ return(1) },

      // Android-only options that will override the defaults set by Phonegap in the
      // generated AndroidManifest.xml
      // See https://developer.android.com/guide/topics/manifest/uses-sdk-element.html
      minSdkVersion: function(){ return(10) },
      targetSdkVersion: function(){ return(19) },

      // iOS7-only options that will make the status bar white and transparent
      iosStatusBar: 'WhiteAndTransparent',

      // If you want to use the Phonegap Build service to build one or more
      // of the platforms specified above, include these options.
      // See https://build.phonegap.com/
      remote: {
        username: 'your_username',
        password: 'your_password',
        platforms: ['android', 'blackberry', 'ios', 'symbian', 'webos', 'wp7']
      },

      // Set an explicit Android permissions list to override the automatic plugin defaults.
      // In most cases, you should omit this setting. See 'Android Permissions' in README.md for details.
      permissions: ['INTERNET', 'ACCESS_COURSE_LOCATION', '...']
    }
  }
})
```



## Dynamic config.xml
[[Back To Top]](#grunt-phonegap)

Beginning with **v0.4.1**, `phonegap.config.config` may be either a string or an object.

As a string, the file is copied directly, as with previous versions.

As an object with the keys `template<String>` and `data<Object>`, the file at `template` will
be processed using [grunt.template](http://gruntjs.com/api/grunt.template).


##### Example

**Gruntfile.js**


```js
  // ...
  phonegap: {
    config: {
      config: {
        template: '_myConfig.xml',
        data: {
          id: 'com.grunt-phonegap.example'
          version: grunt.pkg.version
          name: grunt.pkg.name
        }
      }
  // ...
```

**_myConfig.xml**

```xml
<?xml version='1.0' encoding='utf-8'?>
<widget
  id="<%= id %>"
  version="<%= version %>"
  xmlns="http://www.w3.org/ns/widgets"
  xmlns:gap="http://phonegap.com/ns/1.0">

    <name><%= name %></name>

    <!-- ... -->
</widget>

```


## App Icons
[[Back To Top]](#grunt-phonegap)

If you choose to set `phonegap.config.icons` with one or more icon sizes, these files
will be copied into the appropriate directories to use as your app icon.

You may want to use this feature in conjunction with [grunt-rasterize](https://github.com/logankoester/grunt-rasterize)
to generate the correctly sized icon files from an SVG source.

Currently this feature supports Android, Windows Phone 8, and iOS.

##### Example

```js
  phonegap: {
    config: {
      // ...
      icons: {
      	android: {
          ldpi: 'icon-36-ldpi.png',
          mdpi: 'icon-48-mdpi.png',
          hdpi: 'icon-72-hdpi.png',
          xhdpi: 'icon-96-xhdpi.png'
        },
        wp8: {
          app: 'icon-62-tile.png',
          tile: 'icon-173-tile.png'
        },
        ios: {
          icon29: 'icon29.png',
          icon29x2: 'icon29x2.png',
          icon40: 'icon40.png',
          icon40x2: 'icon40x2.png',
          icon50: 'icon50.png',
          icon50x2: 'icon50x2.png',
          icon57: 'icon57.png',
          icon57x2: 'icon57x2.png',
          icon60: 'icon60.png',
          icon60x2: 'icon60x2.png',
          icon60x3: "icon60x3.png",
          icon72: 'icon72.png',
          icon72x2: 'icon72x2.png',
          icon76: 'icon76.png',
          icon76x2: 'icon76x2.png'
        }
      }
      // ...
    }
  }
```


## versionCode
[[Back To Top]](#grunt-phonegap)

The [config-xml](https://build.phonegap.com/docs/config-xml) documentation from Phonegap Build (the remote build service)
indicate that you can set a **versionCode** for your `AndroidManifest.xml` file inside your `config.xml`. However, `phonegap local`
just ignores that property.

[Google Play](http://developer.android.com/distribute/index.html) will not allow you to upload more than one APK with the same `versionCode`.

If you set a `phonegap.config.versionCode` value (function or literal), `grunt phonegap:build` will post-process the generated
`AndroidManifest.xml` file and set it for you.

In most applications it should simply be an integer that you increment with each release.

See http://developer.android.com/tools/publishing/versioning.html

This option will be ignored for non-Android platforms or when using the remote build service.



## Android Debugging
[[Back To Top]](#grunt-phonegap)

When you use `phonegap:release` to build an apk package for the Android platform,
`grunt-phonegap` will post-process the phonegap-generated `AndroidManifest.xml`
file to set `debuggable=false`, **unless** you set the `phonegap.config.debuggable`
option to true.

A debuggable package cannot be published to the Play store. If you want to generate
an unsigned, debuggable package for testing on your own devices, you can use the
`phonegap:debug:android` task instead to do this.

This feature exists to ensure we get the intended behavior no matter what
Phonegap version you are using. In Phonegap 4.3.x, the release apk is created
with debuggable=true regardless of whether a debug certificate was used. In
Phonegap 4.4.x, this has been corrected.


## minSdkVersion and targetSdkVersion
[[Back To Top]](#grunt-phonegap)

Some Android applications need to force a specific value for `minSdkVersion` and `targetSdkVersion`, for example to enable "[quirks mode](http://developer.android.com/guide/webapps/migrating.html#Pixels)" in Android 4.4's Chrome-based WebView.

Supposedly, [Phonegap Build](https://build.phonegap.com) supports this through a **config.xml** preference [like this](https://github.com/phonegap/build/issues/174#issuecomment-25038854):

    <preference name="android-targetSdkVersion" value="13" />

However, setting this preference appears to have no effect on the output during a local build.

If you set `phonegap.config.minSdkVersion` and/or `phonegap.config.targetSdkVersion`, `grunt phonegap:build` will post-process the generated
`AndroidManifest.xml` file and set it for you.

This option will be ignored for non-Android platforms or when using the remote build service. For remote Android builds, instead try the `android-targetSdkVersion` preference mentioned above.


## Android Permissions
[[Back To Top]](#grunt-phonegap)

If `phonegap.config.permissions` is omitted, plugin permissions will be set automatically by Phonegap. In most cases, this is what you want.

Ordinarily with Phonegap (local), permissions for the Android platform are written to `AndroidManifest.xml`
based on the requirements of the plugins that you have added to your project, so you do not have to worry
about them.

In some (perhaps unusual) situations, you may want to alter these permissions without modifying a plugin.

When you may want to do this:

* To reserve not-yet-used permissions during development
* To enable a plugin that does not require the right permissions for your target version of Android
* While troubleshooting a permissions error in your app.
* When using an advanced Grunt workflow to set your permissions for different builds dynamically (by specifying `phonegap.config.permissions` as a function)

If you need this feature, set `phonegap.config.permissions` to an array of permission basenames, such as ['ACCESS_NETWORK_STATE'].

When `phonegap.config.permissions` is set, **all permissions added by Cordova + plugins will be removed**, giving
you complete control over the permission manifest.

This means you need to explicitely add any permissions required by plugins, or your app will not work.

Be careful to check any permissions your plugins need before adding this feature to your app, and remember to update it
when adding additional plugins later.

If you are using the Phonegap Build cloud service for the Android platform, this setting will have no effect.


## Android Screen Orientation
[[Back To Top]](#grunt-phonegap)

If you need to specify the screen orientation for your app on the Android
platform, you may set a value for `phonegap.config.screenOrientation` to cause
`grunt-phonegap` to post-process the generated `AndroidManifest.xml` and set
the correct value for you.

The value can be any one of the following strings:

  * unspecified
  * behind
  * landscape
  * portrait
  * reverseLandscape
  * reversePortrait
  * sensorLandscape
  * sensorPortrait
  * userLandscape
  * userPortrait
  * sensor
  * fullSensor
  * nosensor
  * user
  * fullUser
  * locked

For an explanation of these options, refer to the `android:screenOrientation` section of [<activity>](https://developer.android.com/guide/topics/manifest/activity-element.html) in the Android developer guide.

This option will be ignored for non-Android platforms or when using the remote build service.


## Application Name
[[Back To Top]](#grunt-phonegap)

If `phonegap.config.androidApplicationName` is a string or function, then it will be applied to the `<application android:name />` attribute in your `AndroidManifest.xml`.

This option should **almost always** be left `undefined`. You will only need to set this if you are implementing a base plugin 
(a Java class extending from `android.app.Application`), for example to [implement crash reporting with ACRA](https://github.com/mWater/cordova-plugin-acra).


## Phonegap Build
[[Back To Top]](#grunt-phonegap)

If you set `phonegap.config.remote` to a subset of `phonegap.config.platforms`, those platforms will be built remotely. This is still somewhat
experimental, and may not integrate with all local features.

If you use Phonegap Build, you should add your Phonegap App ID to your `.cordova/config.json` file - otherwise each build will be treated as a new app toward your account quota.

Example: `{"lib":{"www":{"id":"phonegap","version":"3.3.0"}}, "phonegap": {"id": 1234567}}`

You can find the PhoneGap App ID in your PhoneGap Builds panel.


## Tasks
[[Back To Top]](#grunt-phonegap)

#### phonegap:build[:platform]

Running `phonegap:build` with no arguments will...

* Purge your `phonegap.config.path`
* Copy your `phonegap.config.cordova` and `phonegap.config.root` files into it
* Add any plugins listed in `phonegap.config.plugins`
* ..and then generate a Phonegap build for all platforms listed in `phonegap.config.platforms`

If you pass a specific platform as an argument (eg `grunt phonegap:build:android`), the `phonegap.config.platforms` array will be
ignored and only that specific platform will be built.

#### phonegap:run[:platform][:device]

After a build is complete, the `phonegap:run` grunt task can be used to launch your app
on an emulator or hardware device. It accepts two optional arguments, `platform` and `device`.

Example: `grunt phonegap:run:android:emulator`

If you are using the Android platform, you can see the list of connected devices by running `adb devices`.

The platform argument will default to the first platform listed in `phonegap.config.platforms`.

#### phonegap:release[:platform]

Create a releases/ directory containing a signed application package for distribution.

Currently `android` is the only platform supported by this task. You will need to create
a keystore file at `phonegap.config.key.store` like this:

    $ keytool -genkey -v -keystore release.keystore -alias release -keyalg RSA -keysize 2048 -validity 10000

The keytool command will interactively ask you to set store and alias passwords, which must match
the return value of `phonegap.config.key.aliasPassword` and `phonegap.config.key.storePassword` respectively.

#### phonegap:debug[:platform]

Creates a releases/debug directory containing an unsigned application package with debugging enabled.

Currently `android` is the only platform supported by this task.

By browsing to this APK asset from test hardware device, we can quickly install the APK output from our build.
Then we use chrome://inspect to inspect the network traffic as an example - this is not possible using the signed APK.

#### phonegap:login

Log into the Phonegap Build service with the credentials specified at `phonegap.config.remote.username`
and `phonegap.config.remote.password`.

#### phonegap:logout

Log out of the Phonegap Build service.


## Running the test suite
[[Back To Top]](#grunt-phonegap)

    git clone https://github.com/logankoester/grunt-phonegap.git
    cd grunt-phonegap
    npm install
    git submodule init
    git submodule update
    grunt

Note that not all tests can be run on all platforms. For example, tests depending on the Windows Phone SDK
will be skipped if your OS is detected to be non-Windows.



## Contributing
[[Back To Top]](#grunt-phonegap)

Fork the repo on Github and open a pull request. Note that the files in `tasks/` and `test/` are the output of
CoffeeScript files in `src/`, and will be overwritten if edited by hand.

Likewise, `README.md` is the output of the `grunt docs` task, and will be overwritten. README updates should be made in
the Markdown files under `docs/`.

Before running the included test suite, you must first run `git submodule update` on your local clone (see above).

Please run `grunt build` before submitting a pull request. The build output should be included with your changes.


## Release History
[[Back To Top]](#grunt-phonegap)

You can find [all the changelogs here](/docs/releases).

### Latest changelog is from v0.15.2.md:

#### v0.15.2

  * Adds [grunt-init-phonegap](https://github.com/logankoester/grunt-init-phonegap) project template to make it easier to start new projects
  * Updates `async` and `grunt-contrib-nodeunit` dependencies


## License
[[Back To Top]](#grunt-phonegap)

Copyright (c) 2013-2014 Logan Koester.
Released under the MIT license. See `LICENSE-MIT` for details.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/logankoester/grunt-phonegap/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

[![xrefs](https://sourcegraph.com/api/repos/github.com/logankoester/grunt-phonegap/badges/xrefs.png)](https://sourcegraph.com/github.com/logankoester/grunt-phonegap)
[![funcs](https://sourcegraph.com/api/repos/github.com/logankoester/grunt-phonegap/badges/funcs.png)](https://sourcegraph.com/github.com/logankoester/grunt-phonegap)
[![top func](https://sourcegraph.com/api/repos/github.com/logankoester/grunt-phonegap/badges/top-func.png)](https://sourcegraph.com/github.com/logankoester/grunt-phonegap)
[![library users](https://sourcegraph.com/api/repos/github.com/logankoester/grunt-phonegap/badges/library-users.png)](https://sourcegraph.com/github.com/logankoester/grunt-phonegap)
[![authors](https://sourcegraph.com/api/repos/github.com/logankoester/grunt-phonegap/badges/authors.png)](https://sourcegraph.com/github.com/logankoester/grunt-phonegap)
[![Total views](https://sourcegraph.com/api/repos/github.com/logankoester/grunt-phonegap/counters/views.png)](https://sourcegraph.com/github.com/logankoester/grunt-phonegap)
[![Views in the last 24 hours](https://sourcegraph.com/api/repos/github.com/logankoester/grunt-phonegap/counters/views-24h.png)](https://sourcegraph.com/github.com/logankoester/grunt-phonegap)


