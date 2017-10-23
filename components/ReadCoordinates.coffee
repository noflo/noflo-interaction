noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Read the coordinates from a DOM event'
  c.icon = 'map-marker'
  c.inPorts.add 'event',
    datatype: 'object'
  c.outPorts.add 'screen',
    datatype: 'object'
  c.outPorts.add 'client',
    datatype: 'object'
  c.outPorts.add 'page',
    datatype: 'object'
  c.forwardBrackets =
    event: ['screen', 'client', 'page']
  c.process (input, output) ->
    return unless input.hasData 'event'
    event = input.getData 'event'
    output.sendDone
      screen:
        x: event.screenX
        y: event.screenY
      client:
        x: event.clientX
        y: event.clientY
      page:
        x: event.pageX
        y: event.pageY
