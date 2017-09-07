conf =
  moudle:
    reload: true
    karabiner: true
    app: true
    key: true
    url: true
  karabiner:
    json: '~/.config/karabiner/karabiner.json'
    yaml: '~/.config/karabiner/karabiner.yaml'
    copy: "'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --copy-current-profile-to-system-default-profile"
  app:
    allowOutside: false
  notification:
    up:
      x: 80
      y: 60
    down:
      x: 80
      y: 80

conf
