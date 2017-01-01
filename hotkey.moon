conf = require 'conf'
_ = require 'moses'
mouse = require 'mouse'
layout = require 'layout'
util = require 'util'
app = require 'app'
bind = hs.hotkey.bind
apps = {}
lcagList =
  a: 'com.github.atom'
  b: 'com.tapbots.TweetbotMac'
  c: 'com.apple.iCal'
  d: 'com.eusoft.eudic'
  e: 'com.bohemiancoding.sketch3'
  f: 'com.apple.finder'
  g: 'com.google.Chrome'
  h: layout\leftHalf
  i: 'com.googlecode.iterm2'
  j: layout\center
  k: layout\max
  l: layout\rightHalf
  m: 'com.apple.iChat'
  n: 'com.apple.Notes'
  o: 'com.apple.AddressBook'
  p: 'com.torusknot.SourceTreeNotMAS'
  q: 'com.tencent.qq'
  r: 'com.apple.reminders'
  s: 'com.tinyspeck.slackmacgap'
  t: 'com.tdesktop.Telegram'
  u: 'com.netease.163music'
  v: 'com.googlecode.iterm2'
  w: 'com.tencent.xinWeChat'
  x: 'com.readdle.PDFExpert-Mac'
  y: 'com.agilebits.onepassword4'
  z: ''
  ['0']: ''
  ['1']: ''
  ['2']: ''
  [',']: 'com.apple.systempreferences'
  ['/']: -> hs.openConsole true
  [';']: mouse\clickNotificationUp
  ['\'']: mouse\clickNotificationDown
  tab: layout\screen
  escape: ''
  up: layout\upHalf
  down: layout\downHalf
for k, v in pairs lcagList
  if type(v) == 'function'
    bind conf.lcag, k, v
  elseif #v > 0
    bind conf.lcag, k, app.toggleByBundleID(v)
    _.push apps, v

_.push apps, 'com.apple.notificationcenterui'

hs.hotkey.bind('', 'f9', nil, () ->
  wins = {}
  items = _.each hs.application.runningApplications!, (k, v) ->
    name = v\name!
    id = v\bundleID!
    win = v\allWindows!
    if #win > 0 and not _.include(apps, id)
      _.each win, (k, v) ->
        _.push wins, v
  -- print hs.inspect(wins)
  hs.hints.windowHints(wins, nil, true))
