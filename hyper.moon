_ = require 'lodash'
conf = require 'conf'
mouse = require 'mouse'
layout = require 'layout'
app = require 'app'
bind = hs.hotkey.bind
list =
  a: 'com.github.atom'
  b: 'com.tapbots.TweetbotMac'
  c: 'com.apple.iCal'
  d: 'com.kapeli.dashdoc'
  e: 'com.bohemiancoding.sketch3'
  f: 'com.apple.finder'
  g: ''
  h: layout\leftHalf
  i: 'com.netease.163music'
  j: layout\center
  k: layout\max
  l: layout\rightHalf
  m: 'com.apple.iChat'
  n: 'com.apple.Notes'
  o: 'com.apple.AddressBook'
  p: ''
  q: 'com.tencent.qq'
  r: 'com.apple.reminders'
  s: 'com.tinyspeck.slackmacgap'
  t: 'com.tdesktop.Telegram'
  u: ''
  v: ''
  w: 'com.tencent.xinWeChat'
  x: 'com.readdle.PDFExpert-Mac'
  y: 'com.agilebits.onepassword-osx'
  z: ''
  ['0']: 'com.torusknot.SourceTreeNotMAS'
  -- ['0']: 'com.axosoft.gitkraken'
  ['1']: 'com.googlecode.iterm2'
  -- ['1']: 'co.zeit.hyperterm'
  ['2']: 'com.google.Chrome'
  [',']: 'com.apple.systempreferences'
  ['.']: mouse.clickNotification
  ['\\']: ''
  ['-']: ''
  ['=']: ''
  ['`']: -> hs.openConsole true
  tab: layout\screen
  escape: ''
for k, v in pairs list
  if type(v) == 'function'
    bind conf.hyper0, k, v
  elseif #v > 0
    bind conf.hyper0, k, app.toggleByBundleID(v)
    bind conf.hyper1, k, app.toggleByBundleID(v, true)
