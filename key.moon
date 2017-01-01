_ = require 'moses'
app = require 'app'
util = require 'util'
conf = require 'conf'
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

sys = (name, mods={}) ->
  sysEvent(name, true)\setFlags(mods)\post!
  util.delay conf.sysEventTimeout, ->
    sysEvent(name, false)\setFlags(mods)\post!

key = (mods, key, isdown) ->
  key = if _.isNumber key then key else codes[key]
  keyEvent(mods, 'a', isdown)\setKeyCode key

state = {}

export eventtapWatcher = new({ keyDown, keyUp, flagsChanged }, (e) ->
  type, code, flags = e\getType!, e\getKeyCode!, e\getFlags!
  mods = _.keys flags
  print hs.eventtap.event.types[type], codes[code], code, _.concat(mods, ',')

  -- SPACE -> SPACE/LCAG
  if code == codes.space
    if type == keyDown
      state.spaceDown = true
      state.spaceDownTime = util.now! unless state.spaceDownTime
      return true
    else
      state.spaceDown = false
      if state.spaceCombo
        state.spaceDownTime = nil
        state.spaceCombo = false
        return true
      elseif state.spaceDownTime and (util.now! < state.spaceDownTime + conf.oneTapTimeout)
        state.spaceDownTime = nil
        return true, {
          key mods, code, true
          key mods, code, false
        }
      else
        state.spaceDownTime = nil
        state.spaceCombo = false
        return true
  elseif state.spaceDown
    if type == keyDown
      state.spaceCombo = true
      mods = _.union mods, conf.lcag
      return true, {
        key mods, code, true
        key mods, code, false
      }
    else
      return true

  -- RGUI -> F9
  elseif code == codes.rightCmd
    if _.same(mods, {"cmd"}) and type == flagsChanged
      return true, {
        key {}, codes.f9, true
        key {}, codes.f9, false
      }
    else
      return true

  -- RALT -> F8
  elseif code == codes.rightAlt
    if _.same(mods, {"alt"}) and type == flagsChanged
      return true, {
        key {}, codes.f8, true
        key {}, codes.f8, false
      }
    else
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

  -- LSFT -> F7/LSFT
  elseif code == codes.leftShift and _.same(mods, {"shift"}) and type == flagsChanged
    state.leftShiftDown = util.now!
    return true
  elseif code == codes.leftShift and _.same(mods, {}) and type == flagsChanged
    if state.leftShiftDown and util.now! < (state.leftShiftDown + conf.oneTapTimeout)
      state.leftShiftDown = false
      return true, {
        key mods, codes.f7, true
        key mods, codes.f7, false
      }
    else
      return false

  -- LCTL -> F12/LCTL
  elseif code == codes.leftCtrl and _.same(mods, {"ctrl"}) and type == flagsChanged
    state.leftCtrlDown = util.now!
    return true
  elseif code == codes.leftCtrl and _.same(mods, {}) and type == flagsChanged
    if state.leftCtrlDown and util.now! < (state.leftCtrlDown + conf.oneTapTimeout)
      state.leftCtrlDown = false
      return true, {
        key mods, codes.f12, true
        key mods, codes.f12, false
      }
    else
      return false

  -- LALT -> F11/LALT
  elseif code == codes.leftAlt and _.same(mods, {"alt"}) and type == flagsChanged
    state.leftAltDown = util.now!
    return true
  elseif code == codes.leftAlt and _.same(mods, {}) and type == flagsChanged
    if state.leftAltDown and util.now! < (state.leftAltDown + conf.oneTapTimeout)
      state.leftAltDown = false
      return true, {
        key mods, codes.f11, true
        key mods, codes.f11, false
      }
    else
      return false

  -- LGUI -> F10/LGUI
  elseif code == codes.leftCmd and _.same(mods, {"cmd"}) and type == flagsChanged
    state.leftCmdDown = util.now!
    return true
  elseif code == codes.leftCmd and _.same(mods, {}) and type == flagsChanged
    if state.leftCmdDown and util.now! < (state.leftCmdDown + conf.oneTapTimeout)
      state.leftCmdDown = false
      return true, {
        key mods, codes.f10, true
        key mods, codes.f10, false
      }
    else
      return false

  -- tab -> tab/Layer 1
  elseif code == codes.tab and type == keyDown
    state.oneDown = true
    return true
  elseif code == codes.tab and type == keyUp
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
        q: 'BRIGHTNESS_DOWN'
        w: 'BRIGHTNESS_UP'
        t: 'ILLUMINATION_DOWN'
        y: 'ILLUMINATION_UP'
        u: 'REWIND'
        i: 'PLAY'
        o: 'FAST'
        p: 'MUTE'
        ['[']: 'SOUND_DOWN'
        [']']: 'SOUND_UP'
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
        n: 'home'
        m: 'pagedown'
        [',']: 'pageup'
        ['.']: 'end'
      mod:
        ['\\']: { {}, 'f19' }
        e: { {'cmd'}, 'f19' }
        r: { {'shift'}, 'f19' }
        z: { {'alt'}, 'f19' }
        x: { {'ctrl'}, 'f19' }
        c: { {'cmd', 'ctrl'}, 'f19' }
        v: { {'cmd', 'alt'}, 'f19' }
    layerKey = layer1.key[codes[code]]
    layerSys = layer1.sys[codes[code]]
    layerMod = layer1.mod[codes[code]]
    if layerKey
      return true, {
        key mods, layerKey, true
        key mods, layerKey, false
      }
    elseif layerSys
      sys layerSys
      return true
    elseif layerMod
      { modMods, modKey } = layerMod
      return true, {
        key modMods, modKey, true
        key modMods, modKey, false
      }
    else
      return false
  elseif state.oneDown and type == keyUp
    return true
  state.leftCmdDown = false
  state.leftAltDown = false
  state.leftCtrlDown = false
  state.leftShiftDown = false

  return false
)\start!
