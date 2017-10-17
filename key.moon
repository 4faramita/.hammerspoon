{
  keyStroke: press
  keyStrokes: send
} = hs.eventtap
_ = require 'lodash'
util = require 'util'
app = require 'app'
mouse = require 'mouse'
screen = require 'screen'
layout = require 'layout'
bind = hs.hotkey.bind

appMap =
  a: 'com.github.atom'
  b: 'com.twitter.twitter-mac'
  c: 'com.apple.iCal'
  d: 'com.eusoft.eudic'
  e: 'com.bohemiancoding.sketch3'
  f: 'com.apple.finder'
  g: 'com.google.Chrome'
  h: ''
  i: 'com.googlecode.iterm2'
  j: ''
  k: 'li.zihua.medis'
  l: ''
  m: 'com.apple.iChat'
  n: 'com.apple.Notes'
  o: 'com.apple.AddressBook'
  p: 'com.postmanlabs.mac'
  q: 'com.tencent.qq'
  r: 'com.apple.reminders'
  s: 'com.3tsoftwarelabs.studio3t'
  t: 'com.tdesktop.Telegram'
  u: 'com.netease.163music'
  v: 'com.microsoft.VSCodeInsiders'
  w: 'com.tencent.xinWeChat'
  x: 'com.readdle.PDFExpert-Mac'
  y: 'com.agilebits.onepassword4'
  z: 'io.zeplin.osx'
  ['0']: 'com.torusknot.SourceTreeNotMAS'
  ['1']: ''
  ['2']: ''
  [',']: 'com.apple.systempreferences'
  ['.']: hs.toggleConsole
  ['[']: mouse\clickNotificationUp
  [']']: mouse\clickNotificationDown

_.forEach appMap, (v, k) ->
  if type(v) == 'function'
    bind '⌘⌃⌥', k, v
  elseif #v > 0
    bind '⌘⌃⌥', k, () -> app\toggle(v)

blackList = util.merge(_.values(appMap), { 'com.apple.notificationcenterui', 'com.kapeli.dashdoc' })


hint = () ->
  wins = {}
  _.forEach hs.application.runningApplications!, (v) ->
    name = v\name!
    id = v\bundleID!
    win = v\allWindows!
    if #win > 0 and not _.some(appMap, (v, k) -> v == id) and not _.includes(blackList, id)
      _.forEach win, (v) ->
        _.push wins, v
  hs.hints.windowHints(wins, nil, true)

bind '⌘⌃⌥', 'space', hint

layoutMap =
  s: 'center'
  r: 'maximize'
  ['space']: 'toggle'
  f: 'minimize'
  w: 'upHalf'
  x: 'downHalf'
  a: 'leftHalf'
  d: 'rightHalf'
  q: 'leftUp'
  e: 'rightUp'
  z: 'leftDown'
  c: 'rightDown'
  ['[']: 'preScreen'
  [']']: 'nextScreen'
  ['=']: 'larger'
  ['-']: 'smaller'
  ['1']: 'moveToScreen'
  ['2']: 'moveToScreen'
  ['3']: 'moveToScreen'
  ['0']: 'mouse'
  up: mouse\clickNotificationUp
  down: mouse\clickNotificationDown
  delete: screen\set

_.forEach layoutMap, (v, k) ->
  if type(v) == 'function'
    bind '⌘⌃⌥⇧', k, v
  elseif #v > 0
    bind '⌘⌃⌥⇧', k, () ->
      k = tonumber(k)
      layout[v](layout, if _.isNumber(k) then k)

--
-- new({ keyDown, keyUp, flagsChanged }, (e) ->
--   event, code, flags, raw = e\getType!, e\getKeyCode!, e\getFlags!, e\getRawEventData!
--   mods = _.keys flags
--   name = codes[code]
--   flagsId = raw.NSEventData.modifierFlags
--   -- print hs.eventtap.event.types[type], codes[code], code, table.concat(mods, ",")
--   -- _.print flagsId, '---',raw.CGEventData.keycode, name
--   if false
--     return false
--   elseif flagsId == 1048848
--     -- rightCmd
--     if event == flagsChanged
--       return false
--     if event == keyUp
--       return true
--     if name == 'space'
--       hint!
--     elseif name == 'tab'
--       send hs.pasteboard.getContents!
--     else
--       v = appMap[name]

--     return true
--   elseif flagsId == 524608
--     -- rightAlt
--     if event == flagsChanged
--       return false
--     if event == keyUp
--       return true
--     map =
--       s: 'center'
--       r: 'maximize'
--       ['space']: 'toggle'
--       f: 'minimize'
--       w: 'upHalf'
--       x: 'downHalf'
--       a: 'leftHalf'
--       d: 'rightHalf'
--       q: 'leftUp'
--       e: 'rightUp'
--       z: 'leftDown'
--       c: 'rightDown'
--       ['[']: 'preScreen'
--       [']']: 'nextScreen'
--       ['=']: 'larger'
--       ['-']: 'smaller'
--       ['1']: 'moveToScreen'
--       ['2']: 'moveToScreen'
--       ['3']: 'moveToScreen'
--       ['0']: 'mouse'
--     v = map[name]
--     return true unless v
--     name = tonumber(name)
--     layout[v](layout, if _.isNumber(name) then name)
--     mouse.center!
--     return true
--   elseif flagsId == 11010368
--     -- rightAlt + fn
--     if event == flagsChanged
--       return false
--     if event == keyUp
--       return true
--     map =
--       up: 'clickNotificationUp'
--       down: 'clickNotificationDown'
--     v = map[name]
--     return true unless v
--     mouse[v](mouse)
--     return true
--   return false
-- )\start!
