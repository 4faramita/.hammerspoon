_ = require 'lodash'
layout = require 'layout'
mouse = require 'mouse'
app = require 'app'

layoutLayer = hs.hotkey.modal.new()
-- hs.hotkey.bind '', 'f14', layoutLayer\enter, layoutLayer\exit
-- layoutLayer.entered = -> _.print 'enterd'
-- layoutLayer.exited = -> _.print 'exited'
layoutKeymap =
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
  up: 'northScreen'
  down: 'southScreen'
  left: 'westScreen'
  right: 'eastScreen'
  ['[']: 'preScreen'
  [']']: 'nextScreen'
  ['=']: 'larger'
  ['-']: 'smaller'
  ['1']: 'moveToScreen'
  ['2']: 'moveToScreen'
  ['3']: 'moveToScreen'
_.forEach layoutKeymap, (v, k) ->
  layoutLayer\bind '', k, ->
    k = tonumber(k)
    layout[v] layout, if _.isNumber(k) then k
    mouse.center!

appLayer = hs.hotkey.modal.new()
-- hs.hotkey.bind '', 'f13', appLayer\enter, appLayer\exit
appKeymap =
  a: 'com.github.atom'
  c: 'com.apple.iCal'
  d: 'com.eusoft.eudic'
  e: 'com.bohemiancoding.sketch3'
  f: 'com.apple.finder'
  g: 'com.google.Chrome'
  h: ''
  i: 'com.googlecode.iterm2'
  j: ''
  k: ''
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
_.forEach appKeymap, (v, k) ->
  if type(v) == 'function'
    appLayer\bind '', k, v
  elseif v and #v > 0
    appLayer\bind '', k, -> app\toggle(v)
    appLayer\bind 'shift', k, -> app\toggle(v, true)

layer =
  layout: layoutLayer
  app: appLayer

layer
