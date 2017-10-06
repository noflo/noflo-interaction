noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Listen to pointer events on a DOM element'
  c.inPorts.add 'element',
    datatype: 'object'
  c.inPorts.add 'action',
    datatype: 'string'
    default: 'none'
    control: true
  events = [
    'down'
    'up'
    'cancel'
    'move'
    'over'
    'out'
    'enter'
    'leave'
  ]
  for event in events
    c.outPorts.add event,
      datatype: 'object'
      description: "Sends event on pointer#{event}"
  c.elements = []
  c.tearDown = (callback) ->
    for element in elements
      if element.el.removeAttribute
        element.el.removeAttribute 'touch-action'
      for event in events
        element.el.removeEventListener "pointer#{event}", element["pointer#{event}"], false
      element.ctx.deactivate()
    c.elements = []
    do callback
  c.process (input, output, context) ->
    return unless input.hasData 'element'
    action = if input.hasData('action') then input.getData('action') else 'none'
    data =
      el: input.getData 'element'
      ctx: context
    element.el.setAttribute 'touch-action', action
    events.forEach (event) ->
      data["pointer#{event}"] = (ev) ->
        ev.preventDefault()
        ev.stopPropagation()
        payload = {}
        payload[event] = ev.target.value
        output.send payload
      data.el.addEventListener "pointer#{event}", data["pointer#{event}"], false
    c.elements.push data
    return
