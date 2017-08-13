_ = require 'lodash'
layout = require 'layout'

mouse =
  -- clickNotificationUp: =>
  --   @clickNotification({
  --     x: hs.screen.primaryScreen!\fullFrame!.w-conf.notification.up.x
  --     y: conf.notification.up.y
  --   })
  -- clickNotificationDown: =>
  --   @clickNotification({
  --     x: hs.screen.primaryScreen!\fullFrame!.w-conf.notification.down.x
  --     y: conf.notification.down.y
  --   })
  -- clickNotification: (point) =>
  --   mouse = hs.eventtap.event.newMouseEvent
  --   types = hs.eventtap.event.types
  --   clickState = hs.eventtap.event.properties.mouseEventClickState
  --   mouse(types.leftMouseDown, point)\setProperty(clickState, 1)\post!
  --   mouse(types.leftMouseUp, point)\setProperty(clickState, 1)\post!
  -- saveIfInside: (win) ->
  --   win or= layout\win!
  --   if win
  --     pos = hs.mouse.getAbsolutePosition!
  --     map[tostring(win\id!)] = if hs.geometry(pos)\inside(win\frame!) then pos else nil
  -- save: (win) ->
  --   win or= layout\win!
  --   if win
  --     pos = hs.mouse.getAbsolutePosition!
  --     map[tostring(win\id!)] = pos
  -- load: (win) ->
  --   win or= layout\win!
  --   if win
  --     pos = map[tostring(win\id!)]
  --     if pos
  --       hs.mouse.setAbsolutePosition pos
  -- loadInsideOrCenter: (win) ->
  --   win or= layout\win!
  --   if win
  --     pos = map[tostring(win\id!)]
  --     hs.mouse.setAbsolutePosition if pos and hs.geometry(pos)\inside(win\frame!) then pos else win\frame!.center
  center: (win) ->
    win or= layout\win!
    if win
      hs.mouse.setAbsolutePosition win\frame!.center

mouse
