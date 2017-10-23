noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description =  'Listen to drag events on a DOM element'
  c.icon = 'arrows'
  c.inPorts.add 'element',
    datatype: 'object'
  c.outPorts.add 'start',
    datatype: 'object'
  c.outPorts.add 'movey',
    datatype: 'number'
  c.outPorts.add 'movex',
    datatype: 'number'
  c.outPorts.add 'end',
    datatype: 'object'
  c.elements = []
  c.tearDown = (callback) ->
    for element in c.elements
      element.el.removeEventListener 'dragstart', element.dragstart, false
      element.el.removeEventListener 'drag', element.dragmove, false
      element.el.removeEventListener 'dragend', element.dragend, false
      element.ctx.deactivate()
    c.elements = []
    do callback
  c.forwardBrackets = {}
  c.process (input, output, context) ->
    return unless input.hasData 'element'
    data =
      el: input.getData 'element'
      dragstart: (event) ->
        event.stopPropagation()
        output.send
          start: event
      dragmove: (event) ->
        event.preventDefault()
        event.stopPropagation()
        output.send
          movex: event.clientX
          movey: event.clientY
      dragend: (event) ->
        event.preventDefault()
        event.stopPropagation()
        output.send
          end: event
      ctx: context
    data.el.addEventListener 'dragstart', data.dragstart, false
    data.el.addEventListener 'drag', data.dragmove, false
    data.el.addEventListener 'dragend', data.dragend, false
    c.elements.push data
    return
