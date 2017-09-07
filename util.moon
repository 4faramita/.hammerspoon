util =
  notify: (sub, txt) =>
    unless txt
      txt = sub
      sub = ''
    hs.notify.show 'Hammerspoon', tostring(sub), tostring(txt)
  trim: (str) =>
    string.gsub(str, "^%s*(.-)%s*$", "%1")
  getSysPwd: =>
    @trim hs.execute('security find-generic-password -s hammerspoon -a system -w')
  checkSecurityAgent: =>
    @trim hs.execute('osascript '..hs.configdir..'/lib/checkSecurityAgent.scpt')
  reload: =>
    @notify '配置', '自动重载'
    hs.reload!

util
