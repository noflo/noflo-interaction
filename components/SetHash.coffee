noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Set the hash in browser\'s URL bar'
  c.icon = 'slack'
  c.inPorts.add 'hash',
    datatype: 'string'
  c.outPorts.add 'out',
    datatype: 'string'
  c.process (input, output) ->
    return unless input.hasData 'hash'
    hash = input.getData 'hash'
    window.location.hash = "##{hash}"
    output.sendDone
      out: hash
