_ = require 'lodash'
layout = require 'layout'
conf = require 'conf'

mouse =
  clickNotificationUp: =>
    @clickNotification({
      x: hs.screen.primaryScreen!\fullFrame!.w-conf.notification.up.x
      y: conf.notification.up.y
    })
  clickNotificationDown: =>
    @clickNotification({
      x: hs.screen.primaryScreen!\fullFrame!.w-conf.notification.down.x
      y: conf.notification.down.y
    })
  clickNotification: (point) =>
    mouse = hs.eventtap.event.newMouseEvent
    types = hs.eventtap.event.types
    clickState = hs.eventtap.event.properties.mouseEventClickState
    mouse(types.leftMouseDown, point)\setProperty(clickState, 1)\post!
    mouse(types.leftMouseUp, point)\setProperty(clickState, 1)\post!
  center: (win) ->
    win or= layout\win!
    if win
      hs.mouse.setAbsolutePosition win\frame!.center

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


oldmousepos = {}
scrollmult = -4
new({0,3,5,14,25,26,27}, (e) ->
  oldmousepos = hs.mouse.getAbsolutePosition!
  mods = hs.eventtap.checkKeyboardModifiers!
  pressedMouseButton = e\getProperty(hs.eventtap.event.properties['mouseEventButtonNumber'])
  shouldScroll = 2 == pressedMouseButton

  if shouldScroll
    dx = e\getProperty(hs.eventtap.event.properties['mouseEventDeltaX'])
    dy = e\getProperty(hs.eventtap.event.properties['mouseEventDeltaY'])
    scroll = hs.eventtap.event.newScrollEvent({dx * scrollmult, dy * scrollmult},{},'pixel')
    scroll\post!
    hs.mouse.setAbsolutePosition(oldmousepos)
    return true, {scroll}
  else
    return false
)\start!

mouse
