conf = require 'conf'
util = require 'util'
{
  keyStroke: press
  keyStrokes: send
  event:
    newKeyEvent: keyEvent
} = hs.eventtap

m = hs.hotkey.modal.new '', conf.textHotKey
exit = ->
  m\exit!
m.entered = =>
  hs.alert.show '¯\\_(ツ)_/¯ enter', 0.5
  util.delay conf.textAutoExit, ->
    unless m.block
      hs.alert.show '¯\\_(ツ)_/¯ exit', 0.5
    exit!

-- m.exited = =>

m\bind '', 'escape', exit

for k, { key, text, enter } in pairs conf.text
  m\bind '', key, k,
    ->
      m.block = true
      util.delay conf.textTimeout, ->
        send text
        press {}, 'return' if enter,
    exit

m\bind '', conf.textHotKey, 'Clipboard',
  ->
    m.block = true
    util.delay conf.textTimeout, ->
      send hs.pasteboard.getContents!,
  exit
