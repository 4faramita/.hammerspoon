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

mouse
