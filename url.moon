_ = require 'lodash'
util = require 'util'

hs.urlevent.bind('test', (name, data) ->
  _.print 'name', name
  _.print 'data', data
)
