noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.icon = 'rss'
  c.description = 'Listen to custom events on a DOM element'
  c.inPorts.add 'element',
    datatype: 'object'
  c.inPorts.add 'event',
    datatype: 'string'
  c.outPorts.add 'out',
    datatype: 'object'
  c.elements = []
  c.tearDown = (callback) ->
    for element in c.elements
      element.el.removeEventListener element.eventName, element.onEvent, false
      element.ctx.deactivate()
    c.elements = []
    do callback
  c.forwardBrackets = {}
  c.process (input, output, context) ->
    return unless input.hasData 'element', 'event'
    el = input.getData 'element'
    eventName = input.getData 'event'
    data =
      el: el
      eventName: eventName
      onEvent: (event) ->
        event.preventDefault()
        event.stopPropagation()
        event.eventName = eventName
        output.send
          out: event
      ctx: context
    data.el.addEventListener eventName, data.onEvent, false
    c.elements.push data
    return
