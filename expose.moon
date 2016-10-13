hs.expose.ui.fitWindowsInBackground = false

expose = hs.expose.new nil, {}

hs.hotkey.bind 'alt','tab','Expose', ->
  expose\toggleShow!
