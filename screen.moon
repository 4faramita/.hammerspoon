_ = require 'lodash'
util = require 'util'

screen =
  set: () ->
    _.forEach  hs.screen.allScreens!, (i) ->
      -- print i, i\name!, i\id! == 724068181, 724067150
      -- 724068181	90
      -- 724067150	0
      -- print i\id!, i\rotate!
      id = i\id!
      if i\name! == 'Color LCD'
        return
      if i\rotate! == 0
        i\rotate 90
      elseif i\rotate! == 90
        i\rotate 0

-- hs.screen.watcher.new(() ->
--   screen.set!
-- )\start!

screen
