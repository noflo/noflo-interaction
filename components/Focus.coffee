noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'focus element'
  c.inPorts.add 'element',
    datatype: 'object'
    description: 'element to be focused'
    control: true
  c.inPorts.add 'trigger',
    datatype: 'bang'
    description: 'trigger focus'
  c.outPorts.add 'out',
    datatype: 'bang'
  c.process (input, output) ->
    return unless input.hasData 'element', 'trigger'
    element = input.getData 'element'
    input.getData 'trigger'
    window.setTimeout ->
      element.focus()
      output.sendDone
        out: true
    , 0
