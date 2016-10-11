conf = require 'conf'
util = require 'util'
_ = require 'lodash'

isExternalDevice = (e) ->
  _.includes(conf.externalDevice.productName, e.productName) or _.includes(conf.externalDevice.productID, e.productID)

toggleInternalKeyboard = (load, slient) ->
  hs.execute("echo #{util.getSystemPwd()} | sudo -S #{if load then 'kextload' else 'kextunload'} /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/")
  util\notify('内置键盘', if load then '启用' else '禁用') unless slient

for k, v in pairs(hs.usb.attachedDevices())
  if isExternalDevice v
    return toggleInternalKeyboard false
toggleInternalKeyboard true, true

export usbWatcher = hs.usb.watcher.new((e)->
  if isExternalDevice(e)
    if e.eventType == 'added'
      toggleInternalKeyboard false
    elseif e.eventType == 'removed'
      toggleInternalKeyboard true
)\start!
