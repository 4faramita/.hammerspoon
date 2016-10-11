hs.window.animationDuration = 0

layout =
  frontmost: ->
    hs.window.frontmostWindow!
  leftHalf: =>
    @frontmost!\move hs.layout.left50
  rightHalf: =>
    @frontmost!\move hs.layout.right50
  max: =>
    @frontmost!\maximize!
  center: =>
    @frontmost!\move('[25,25,75,75]')
  screen: =>
    win = @frontmost!
    win\moveToScreen win\screen!\next!, true, true

layout
