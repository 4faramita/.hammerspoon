-- 通知
function notify(sub, text)
  hs.notify.show('Hammerspoon', (text and sub) or '', text or sub)
end

-- 重载
function reload()
  notify('重新加载')
  hs.reload()
end

util = hs.fnutils

-- 判断是否为外接设备
function isExternalDevice (e)
  return util.contains(conf.externalDevice.productID, e.productID) or util.contains(conf.externalDevice.productName, e.productName)
end

-- 当前时间
function now ()
  return hs.timer.secondsSinceEpoch()
end

-- AppleScript
function AS (val)
  return hs.osascript.applescript(val)
end
function SH (val)
  return hs.execute(val)
end

function getSystemPwd ()
  return SH('security find-generic-password -s hammerspoon -a system -w')
end

-- delay
function delay (...)
  hs.timer.doAfter(...)
end

-- inspect
inspect = hs.inspect

-- debug
function put (...)
  if conf.debug then
    print(...)
  end
end

-- includes
function includes (list, item)
  for i=1,#list+1 do
    if item == list[i] then
      return true
    end
  end
  return false
end

function runningApp (id, success, fail)
  local app = hs.application.get(id)
  if app then
    app:activate()
    delay(0.1, function ()
      success()
    end)
    delay(0.2, function ()
      app:hide()
    end)
  else
    fail()
  end
end
