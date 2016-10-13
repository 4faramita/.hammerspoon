-- 取 Apple 键盘和 60% 键盘相同的部分作为基础
-- ,-----------------------------------------------------------------------------------------.
-- |  `  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |  9  |  0  |  -  |  =  |   BSPC    |
-- |-----------------------------------------------------------------------------------------|
-- |   TAB  |  Q  |  W  |  E  |  R  |  T  |  Y  |  U  |  I  |  O  |  P  |  [  |  ]  |    \   |
-- |-----------------------------------------------------------------------------------------|
-- |    ESC    |  A  |  S  |  D  |  F  |  G  |  H  |  J  |  K  |  L  |  ;  |  '  |           |
-- |-----------------------------------------------------------------------------------------|
-- |    LSFT     |  Z  |  X  |  C  |  V  |  B  |  N  |  M  |  ,  |  .  |  /  |      UP       |
-- |-----------------------------------------------------------------------------------------|
-- |     | LCTL | LALT | LGUI |              SPACE                     | RGUI |LEFT|DOWN|RGHT|
-- `-----------------------------------------------------------------------------------------'
-- Layer 0(默认层)
-- ,-----------------------------------------------------------------------------------------.
-- |   |1/Layer1|2/Layer2|     |     |     |     |     |     |     |     |     |     |       |
-- |-----------------------------------------------------------------------------------------|
-- |        |     |     |     |     |     |     |     |     |     |     |     |     |        |
-- |-----------------------------------------------------------------------------------------|
-- |   ESC/LCTL  |     |     |     |     |     |     |     |     |     |     |     |         |
-- |-----------------------------------------------------------------------------------------|
-- |   F13/LSFT   |     |     |     |     |     |     |     |     |     |     |              |
-- |-----------------------------------------------------------------------------------------|
-- |    |F12/LCTL|F11/LALT|F10/LGUI|          SPACE/HYPER0          |F9/HYPER1|    |    |    |
-- `-----------------------------------------------------------------------------------------'
-- Layer 1
-- ,-----------------------------------------------------------------------------------------.
-- |     |     |     |     |     |     |     |     |     |     |     |     |     |    Del    |
-- |-----------------------------------------------------------------------------------------|
-- |       |       |     |     |     |     |     |     |     |     |     |     |     |       |
-- |-----------------------------------------------------------------------------------------|
-- |            |  B-  |  B+  | KB- | KB+ | KBT | LEFT| DOWN | UP | RGHT |     |     |       |
-- |-----------------------------------------------------------------------------------------|
-- |             |  V-  |  V+  | MUTE | MPRV | MPLY | MNXT |                                 |
-- |-----------------------------------------------------------------------------------------|
-- |                                                                                         |
-- `-----------------------------------------------------------------------------------------'
-- Layer 2
-- ,-----------------------------------------------------------------------------------------.
-- |     |     |     |     |     |     |     |     |     |     |     |     |     |           |
-- |-----------------------------------------------------------------------------------------|
-- |        |     |     |     |     |     |     |     |     |     |     |     |     |        |
-- |-----------------------------------------------------------------------------------------|
-- |         |     |     |     |     |     | HOME | PGDN | PGUP | END |     |     |          |
-- |-----------------------------------------------------------------------------------------|
-- |              |     |     |     |     |     |     |     |     |     |     |              |
-- |-----------------------------------------------------------------------------------------|
-- |     |       |      |      |                                       |      |    |    |    |
-- `-----------------------------------------------------------------------------------------'
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
  keyStrokes: text
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
  util.delay 0.1, ->
    sysEvent(name, false)\setFlags(mods)\post!

key = (mods, key, isdown) ->
  key = if _.isNumber key then key else codes[key]
  keyEvent(mods, '', isdown)\setKeyCode key

state = {}

export eventtapWatcher = new({ keyDown, keyUp, flagsChanged }, (e) ->
  keyboardType = e\getProperty keyboardEventKeyboardType
  return unless keyboardType and _.includes conf.enabledDevice, keyboardType
  type, code, flags = e\getType!, e\getKeyCode!, e\getFlags!
  mods = _.keys flags
  print type, code, _.str(mods)

  -- SPACE -> SPACE/HYPER0
  if code == codes.space and type == keyDown
    state.spaceDown = true
    return true
  elseif code == codes.space and type == keyUp
    state.spaceDown = false
    if state.spaceCombo
      state.spaceCombo = false
      return true
    else
      return true, {
        key mods, code, true
        key mods, code, false
      }
  elseif state.spaceDown and type == keyDown
    state.spaceCombo = true
    mods = _.union mods, conf.hyper0
    return true, {
      key mods, code, true
      key mods, code, false
    }
  elseif state.spaceDown and type == keyUp
    return true

  -- RGUI -> F9/HYPER1
  elseif code == codes.rightCmd and _.str(mods) == '{"cmd"}' and type == flagsChanged
    state.rightCmdDown = hs.timer.secondsSinceEpoch!
    return true
  elseif code == codes.rightCmd and _.str(mods) == '{}' and type == flagsChanged
    if state.rightCmdCombo
      state.rightCmdDown = false
      state.rightCmdCombo = false
      return true
    elseif hs.timer.secondsSinceEpoch! < state.rightCmdDown + conf.oneTapTimeout
      state.rightCmdDown = false
      return true, {
        key mods, codes.f9, true
        key mods, codes.f9, false
      }
  elseif state.rightCmdDown and type == keyDown
    state.rightCmdCombo = true
    mods = _.union mods, conf.hyper1
    return true, {
      key mods, code, true
      key mods, code, false
    }
  elseif state.rightCmdDown and type == keyUp
    return true

  -- ESC -> ESC/LCTL
  elseif code == codes.escape and type == keyDown
    state.escapeDown = true
    return true
  elseif code == codes.escape and type == keyUp
    state.escapeDown = false
    if state.escapeCombo
      state.escapeCombo = false
      return true
    else
      return true, {
        key mods, code, true
        key mods, code, false
      }
  elseif state.escapeDown and type == keyDown
    state.escapeCombo = true
    mods = _.union mods, {'ctrl'}
    return true, {
      key mods, code, true
      key mods, code, false
    }
  elseif state.escapeDown and type == keyUp
    return true

  -- LSFT -> F13/LSFT
  elseif code == codes.leftShift and _.str(mods) == '{"shift"}' and type == flagsChanged
    state.leftShiftDown = hs.timer.secondsSinceEpoch!
    return true
  elseif code == codes.leftShift and _.str(mods) == '{}' and type == flagsChanged
    if state.leftShiftDown and hs.timer.secondsSinceEpoch! < state.leftShiftDown + conf.oneTapTimeout
      state.leftShiftDown = false
      return true, {
        key mods, codes.f13, true
        key mods, codes.f13, false
      }

  -- LCTL -> F12/LCTL
  elseif code == codes.leftCtrl and _.str(mods) == '{"ctrl"}' and type == flagsChanged
    state.leftCtrlDown = hs.timer.secondsSinceEpoch!
    return true
  elseif code == codes.leftCtrl and _.str(mods) == '{}' and type == flagsChanged
    if state.leftCtrlDown and hs.timer.secondsSinceEpoch! < state.leftCtrlDown + conf.oneTapTimeout
      state.leftCtrlDown = false
      return true, {
        key mods, codes.f12, true
        key mods, codes.f12, false
      }

  -- LALT -> F11/LALT
  elseif code == codes.leftAlt and _.str(mods) == '{"alt"}' and type == flagsChanged
    state.leftAltDown = hs.timer.secondsSinceEpoch!
    return true
  elseif code == codes.leftAlt and _.str(mods) == '{}' and type == flagsChanged
    if state.leftAltDown and hs.timer.secondsSinceEpoch! < state.leftAltDown + conf.oneTapTimeout
      state.leftAltDown = false
      return true, {
        key mods, codes.f11, true
        key mods, codes.f11, false
      }

  -- LGUI -> F10/LGUI
  elseif code == codes.leftCmd and _.str(mods) == '{"cmd"}' and type == flagsChanged
    state.leftCmdDown = hs.timer.secondsSinceEpoch!
    return true
  elseif code == codes.leftCmd and _.str(mods) == '{}' and type == flagsChanged
    if state.leftCmdDown and hs.timer.secondsSinceEpoch! < state.leftCmdDown + conf.oneTapTimeout
      state.leftCmdDown = false
      return true, {
        key mods, codes.f10, true
        key mods, codes.f10, false
      }

  -- 2 -> 2/Layer 2
  elseif code == codes['2'] and type == keyDown
    state.twoDown = true
    return true
  elseif code == codes['2'] and type == keyUp
    state.twoDown = false
    if state.twoCombo
      state.twoCombo = false
      return true
    else
      return true, {
        key mods, code, true
        key mods, code, false
      }
  elseif state.twoDown and type == keyDown
    state.twoCombo = true
    layer2 =
      h: 'home'
      j: 'pagedown'
      k: 'pageup'
      l: 'end'
    code = layer2[codes[code]] or code
    return true, {
      key mods, code, true
      key mods, code, false
    }
  elseif state.twoDown and type == keyUp
    return true

  -- 1 -> 1/Layer 1
  elseif code == codes['1'] and type == keyDown
    state.oneDown = true
    return true
  elseif code == codes['1'] and type == keyUp
    state.oneDown = false
    if state.oneCombo
      state.oneCombo = false
      return true
    else
      return true, {
        key mods, code, true
        key mods, code, false
      }
  elseif state.oneDown and type == keyDown
    state.oneCombo = true
    layer1 =
      sys:
        z: 'SOUND_DOWN'
        x: 'SOUND_UP'
        c: 'MUTE'
        a: 'BRIGHTNESS_DOWN'
        s: 'BRIGHTNESS_UP'
        d: 'ILLUMINATION_DOWN'
        f: 'ILLUMINATION_UP'
        g: 'ILLUMINATION_TOGGLE'
      key:
        ['1']: 'f1'
        ['2']: 'f2'
        ['3']: 'f3'
        ['4']: 'f4'
        ['5']: 'f5'
        ['6']: 'f6'
        ['7']: 'f7'
        ['8']: 'f8'
        ['9']: 'f9'
        ['0']: 'f10'
        ['-']: 'f11'
        ['=']: 'f12'
        delete: 'forwarddelete'
        h: 'left'
        j: 'down'
        k: 'up'
        l: 'right'
    layerKey = layer1.key[codes[code]]
    layerSys = layer1.sys[codes[code]]
    if layerKey
      return true, {
        key mods, layerKey, true
        key mods, layerKey, false
      }
    elseif layerSys
      sys layerSys
      return true
    elseif code == codes.v
      app.running 'com.netease.163music',
        () -> press({'cmd'}, 'left'),
        () -> sys 'PREVIOUS'
      return true
    elseif code == codes.b
      app.running 'com.netease.163music',
        () -> press({}, 'space'),
        () -> sys 'PLAY'
      return true
    elseif code == codes.n
      app.running 'com.netease.163music',
        () -> press({'cmd'}, 'right'),
        () -> sys 'NEXT'
      return true
  elseif state.oneDown and type == keyUp
    return true

  state.leftCmdDown = false
  state.leftAltDown = false
  state.leftCtrlDown = false
  state.leftShiftDown = false
)\start!
