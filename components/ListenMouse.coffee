noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Listen to mouse events on a DOM element'
  c.inPorts.add 'element',
    datatype: 'object'
  c.outPorts.add 'click',
    datatype: 'object'
  c.outPorts.add 'dblclick',
    datatype: 'object'
  c.elements = []
  c.tearDown = (callback) ->
    for element in elements
      element.el.removeEventListener 'click', element.click, false
      element.el.removeEventListener 'dblclick', element.dblclick, false
      element.ctx.deactivate()
    c.elements = []
    do callback
  c.process (input, output, context) ->
    return unless input.hasData 'element'
    data =
      el: input.getData 'element'
      click: (event) ->
        event.preventDefault()
        event.stopPropagation()
        output.send
          click: event
      dblclick: (event) ->
        event.preventDefault()
        event.stopPropagation()
        output.send
          dblclick: event
      ctx: context
    data.el.addEventListener 'click', data.click, false
    data.el.addEventListener 'dblclick', data.dblclick, false
    c.elements.push data
    return
