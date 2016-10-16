conf = require 'conf'
util = require 'util'
{
  keyStroke: press
  keyStrokes: send
  event:
    newKeyEvent: keyEvent
} = hs.eventtap

m = hs.hotkey.modal.new '', 'f20'
exit = ->
  m\exit!

m\bind '', 'escape', exit

for k, { key, text, enter } in pairs conf.text
  m\bind '', key, k,
    ->
      m.block = true
      util.delay conf.textTimeout, ->
        send text
        press {}, 'return' if enter,
    exit

hs.hotkey.bind '', conf.textHotKey, nil,
  ->
    hs.alert '¯\\_(ツ)_/¯ enter'
    m\enter!
    util.delay conf.textAutoExit, ->
      unless m.block
        hs.alert '¯\\_(ツ)_/¯ exit'
      m\exit!
