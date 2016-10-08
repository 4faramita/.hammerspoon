function moveMouseToFrontmostWin ()
  local winFrame = win():frame()
  local mousePosition = hs.mouse.getRelativePosition()
  local fullFrame = hs.mouse.getCurrentScreen():fullFrame()
  hs.mouse.setAbsolutePosition({x=winFrame.x+winFrame.w*mousePosition.x/fullFrame.w, y=winFrame.y+winFrame.h*mousePosition.y/fullFrame.h})
end
local function toggleAppByBundleID (id, max)
  return function ()
    local app = hs.application.frontmostApplication()
    if app and app:bundleID() == id then
      app:hide()
    else
      hs.application.launchOrFocusByBundleID(id)
      moveMouseToFrontmostWin()
      if max then
        win():maximize()
      end
    end
  end
end
function clickNotification ()
  local mouse = hs.eventtap.event.newMouseEvent
  local types = hs.eventtap.event.types
  local point = {
    x=hs.screen.primaryScreen():fullFrame().w-80,
    y=65,
  }
  local clickState = hs.eventtap.event.properties.mouseEventClickState
  mouse(types.leftMouseDown, point):setProperty(clickState, 1):post()
  mouse(types.leftMouseUp, point):setProperty(clickState, 1):post()
end
for k,v in pairs({
  a = 'com.github.atom',
  b = 'com.tapbots.TweetbotMac',
  c = 'com.apple.iCal',
  d = '',
  e = 'com.bohemiancoding.sketch3',
  f = 'com.apple.finder',
  g = '',
  h = winHalfLeft,
  i = 'com.netease.163music',
  j = winCenter,
  k = winMax,
  l = winRightHalf,
  m = 'com.apple.iChat',
  n = 'com.apple.Notes',
  o = 'com.apple.AddressBook',
  p = '',
  q = 'com.tencent.qq',
  r = 'com.apple.reminders',
  s = 'com.tinyspeck.slackmacgap',
  t = 'com.tdesktop.Telegram',
  u = '',
  v = '',
  w = 'com.tencent.xinWeChat',
  x = 'com.readdle.PDFExpert-Mac',
  y = 'com.agilebits.onepassword-osx',
  z = '',
  ['0'] = 'com.torusknot.SourceTreeNotMAS',
  ['1'] = 'com.googlecode.iterm2',
  -- ['1'] = 'co.zeit.hyperterm',
  ['2'] = 'com.google.Chrome',
  [','] = 'com.apple.systempreferences',
  ['.'] = clickNotification,
  ['\\'] = reload,
  ['-'] = saveLayout,
  ['='] = restoreLayout,
  ['tab'] = winLoopScreen,
  escape = moveMouseToFrontmostWin,
}) do
  if type(v) == 'function' then
    hs.hotkey.bind('cmd-ctrl-alt', k, v)
  elseif #v > 0 then
    hs.hotkey.bind('cmd-ctrl-alt', k, toggleAppByBundleID(v))
    hs.hotkey.bind('cmd-ctrl-alt-shift', k, toggleAppByBundleID(v, true))
  end
end
