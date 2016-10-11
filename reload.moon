_ = require 'lodash'
util = require 'util'

export confWatcher = hs.pathwatcher.new(hs.configdir, (files) ->
  _.find files, (file) ->
    if file\sub(-4) == 'moon'
      util\reload!
)\start!
