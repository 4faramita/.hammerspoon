conf = require 'conf'
util = require 'util'
_ = require 'lodash'

isExternalDevice = (e) ->
  _.includes(conf.externalDevice.productName, e.productName) or _.includes(conf.externalDevice.productID, e.productID)

toggleInternalKeyboard = (load, slient) ->
  hs.execute("echo #{util.getSystemPwd()} | sudo -S #{if load then 'kextload' else 'kextunload'} /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/")
  util\notify('内置键盘', if load then '启用' else '禁用') unless slient

checkKeyboard = ->
  for k, v in pairs(hs.usb.attachedDevices())
    if isExternalDevice v
      return toggleInternalKeyboard false
  toggleInternalKeyboard true


export usbWatcher = hs.usb.watcher.new((e)->
  checkKeyboard!
)\start!

export caffeinateWatcher = hs.caffeinate.watcher.new((e) ->
  -- 5, lock; 6, unlock;
  -- sleep display: 3, 10; 4, 11
  -- sleep: 3, 10, 0, 4, 11
  if e == hs.caffeinate.watcher.screensDidUnlock
    checkKeyboard!
)\start!

checkKeyboard!
