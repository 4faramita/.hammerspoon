{
  :new
  keyStroke: press
  keyStrokes: send
  event:
    types:
      :keyDown
      :keyUp
      :flagsChanged
    properties:
      :keyboardEventKeyboardType
      :keyboardEventAutorepeat
      :eventSourceUnixProcessID
    newKeyEvent: keyEvent
    newSystemKeyEvent: sysEvent
} = hs.eventtap

key =
  press: press
  send: send

key
