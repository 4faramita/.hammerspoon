util =
  notify: (sub, txt) =>
    print sub, txt
    unless txt
      txt = sub
      sub = ''
    hs.notify.show 'Hammerspoon', tostring(sub), tostring(txt)
  trim: (str) =>
    string.gsub(str, "^%s*(.-)%s*$", "%1")
  exec: (cmd) =>
    @trim hs.execute(cmd)
  getSysPwd: =>
    @exec('security find-generic-password -s hammerspoon -a system -w')
  checkSecurityAgent: =>
    @exec('osascript '..hs.configdir..'/lib/checkSecurityAgent.scpt')
  reload: =>
    @notify '配置', '自动重载'
    hs.reload!
  merge: (t1, t2) ->
    for k,v in ipairs(t2) do
       table.insert(t1, v)
    t1
util
