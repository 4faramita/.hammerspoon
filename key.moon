_ = require 'lodash'
app = require 'app'
util = require 'util'
conf = require 'conf'
codes = hs.keycodes.map
codes.leftShift = 56
codes.leftCtrl = 59
codes.leftAlt = 58
codes.leftCmd = 55
codes.rightCmd = 54
{
  :new
  keyStroke: press
  event:
    types:
      :keyDown
      :keyUp
      :flagsChanged
    properties:
      :keyboardEventKeyboardType
    newKeyEvent: keyEvent
    newSystemKeyEvent: sysEvent
} = hs.eventtap

sys = (name, mods={}) ->
  sysEvent(name, true)\setFlags(mods)\post!
  util.delay conf.sysEventTimeout, ->
    sysEvent(name, false)\setFlags(mods)\post!

key = (mods, key, isdown) ->
  key = if _.isNumber key then key else codes[key]
  keyEvent(mods, '', isdown)\setKeyCode key

state = {
  startTime: util.now!
}

export eventtapWatcher = new({ keyDown, keyUp, flagsChanged }, (e) ->
  type, code, flags = e\getType!, e\getKeyCode!, e\getFlags!
  mods = _.keys flags
  print math.floor((util.now!-state.startTime+0.5)*100)/100, type, code, _.str(mods) 

  if _.str(mods) == '{"alt", "cmd", "ctrl"}'
    -- print util.now!-state.lastKeyDown
    if state.lastKeyDown and util.now! < state.lastKeyDown + conf.oneTapTimeout
      return true
    else
      return
  else
    if type == keyDown
      state.lastKeyDown = util.now!
    return
)\start!
