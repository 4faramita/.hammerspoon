hs.hotkey.bind('cmd-alt-ctrl', '\\', nil, function()
  hs.notify.show('Hammerspoon', '配置', '重载')
  hs.reload()
end)

require 'moonscript'
require 'index'
