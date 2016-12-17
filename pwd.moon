conf = require 'conf'
util = require 'util'
_ = require 'lodash'
{
  keyStroke: press
  keyStrokes: send
  event:
    newKeyEvent: keyEvent
} = hs.eventtap

state = {}

hs.application.watcher.new((name, event, app)->{
  -- _.print name, event, app
  if name=='SecurityAgent'
    if event == 5
      state.inSecurityAgent = true
    elseif event == 6
      state.inSecurityAgent = nil
  elseif state.inSecurityAgent and event == 6
    inList = _.includes(conf.securityAgentWhiteList, name)
    inListReturn = _.includes(conf.securityAgentWhiteListReturn, name)
    if inList or inListReturn
      send util.getSystemPwd!
    if inListReturn
      press {}, 'return'
})\start!
