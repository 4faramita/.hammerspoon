layout = require 'layout'

mouse =
  clickNotification: ->
    mouse = hs.eventtap.event.newMouseEvent
    types = hs.eventtap.event.types
    clickState = hs.eventtap.event.properties.mouseEventClickState
    point =
      x: hs.screen.primaryScreen!\fullFrame!.w-80
      y: 65
    mouse(types.leftMouseDown, point)\setProperty(clickState, 1)\post!
    mouse(types.leftMouseUp, point)\setProperty(clickState, 1)\post!
  frontmost: ->
    winFrame = layout.frontmost!\frame!
    mousePosition = hs.mouse.getRelativePosition!
    fullFrame = hs.mouse.getCurrentScreen!\fullFrame!
    point =
      x: winFrame.x+winFrame.w*mousePosition.x/fullFrame.w
      y: winFrame.y+winFrame.h*mousePosition.y/fullFrame.h
    hs.mouse.setAbsolutePosition point

mouse
