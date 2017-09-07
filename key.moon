{
  :new
  keyStroke: press
  keyStrokes: send
  event:
    types:
      :keyDown
      :keyUp
      :flagsChanged
    properties:
      :keyboardEventKeyboardType
      :keyboardEventAutorepeat
      :eventSourceUnixProcessID
    newKeyEvent: keyEvent
    newSystemKeyEvent: sysEvent
} = hs.eventtap

_ = require 'lodash'
app = require 'app'
mouse = require 'mouse'
layout = require 'layout'
codes = hs.keycodes.map
codes.leftShift = 56
codes.leftCtrl = 59
codes.leftAlt = 58
codes.leftCmd = 55
codes.rightCmd = 54
codes.rightAlt = 61
{
  :new
  keyStroke: press
  event:
    types:
      :keyDown
      :keyUp
      :flagsChanged
    newKeyEvent: keyEvent
    newSystemKeyEvent: sysEvent
} = hs.eventtap

-- sys = (name, mods={}) ->
--   sysEvent(name, true)\setFlags(mods)\post!
--   util.delay conf.sysEventTimeout, ->
--     sysEvent(name, false)\setFlags(mods)\post!
--
key = (mods, key, isdown) ->
  key = if _.isNumber key then key else codes[key]
  keyEvent(mods, 'a', isdown)\setKeyCode key

appMap =
  a: 'com.github.atom'
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

hint = () ->
  wins = {}
  _.forEach hs.application.runningApplications!, (v) ->
    name = v\name!
    id = v\bundleID!
    win = v\allWindows!
    if #win > 0 and not _.some(appMap, (v, k) -> v == id)
      _.forEach win, (v) ->
        _.push wins, v
  hs.hints.windowHints(wins, nil, true)

new({ keyDown, keyUp, flagsChanged }, (e) ->
  event, code, flags, raw = e\getType!, e\getKeyCode!, e\getFlags!, e\getRawEventData!
  mods = _.keys flags
  name = codes[code]
  flagsId = raw.NSEventData.modifierFlags
  -- print hs.eventtap.event.types[type], codes[code], code, table.concat(mods, ",")
  -- _.print flagsId, '---',raw.CGEventData.keycode, name
  if false
    return false
  elseif flagsId == 1048848
    -- rightCmd
    if event == flagsChanged
      return false
    if event == keyUp
      return true
    if name == 'space'
      hint!
    elseif name == 'tab'
      send hs.pasteboard.getContents!
    else
      v = appMap[name]
      return true unless v
      if type(v) == 'function'
        v!
      else
        app\toggle(v)
    return true
  elseif flagsId == 524608
    -- rightAlt
    if event == flagsChanged
      return false
    if event == keyUp
      return true
    map =
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
    v = map[name]
    return true unless v
    name = tonumber(name)
    layout[v](layout, if _.isNumber(name) then name)
    mouse.center!
    return true
  elseif flagsId == 11010368
    -- rightAlt + fn
    if event == flagsChanged
      return false
    if event == keyUp
      return true
    map =
      up: 'clickNotificationUp'
      down: 'clickNotificationDown'
    v = map[name]
    return true unless v
    mouse[v](mouse)
    return true
  return false
)\start!
