mouse = require 'mouse'
util = require 'util'
layout = require 'layout'

app =
  toggleByBundleID: (id, max) ->
    () ->
      app = hs.application.frontmostApplication!
      if app and app\bundleID! == id
        app\hide!
      else
        hs.application.launchOrFocusByBundleID id
        mouse.frontmost!
        layout\max! if max
  running: (id, success, fail) ->
    app = hs.application.get id
    if app
      app\activate!
      util.delay 0.1, ->
        success!
      util.delay 0.2, ->
        app\hide!
    else
      fail!
app
