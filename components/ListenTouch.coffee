noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Listen to touch events on a DOM element'
  c.icon = 'hand-o-up'
  c.inPorts.add 'element',
    datatype: 'object'
  c.outPorts.add 'start',
    datatype: 'object'
  c.outPorts.add 'movex',
    datatype: 'number'
  c.outPorts.add 'movey',
    datatype: 'number'
  c.outPorts.add 'end',
    datatype: 'object'
  c.elements = []
  c.tearDown = (callback) ->
    for element in elements
      element.el.removeEventListener 'touchstart', element.touchstart, false
      element.el.removeEventListener 'touchmove', element.touchmove, false
      element.el.removeEventListener 'touchend', element.touchend, false
      element.ctx.deactivate()
    c.elements = []
    do callback
  c.forwardBrackets = {}
  c.process (input, output, context) ->
    return unless input.hasData 'element'
    data =
      el: input.getData 'element'
      touchstart: (event) ->
        event.preventDefault()
        event.stopPropagation()
        return unless event.changedTouches
        return unless event.changedTouches.length
        for touch, idx in event.changedTouches
          output.send
            start: new noflo.IP 'data', event,
              touch: idx
      touchmove: (event) ->
        event.preventDefault()
        event.stopPropagation()
        return unless event.changedTouches
        return unless event.changedTouches.length
        for touch, idx in event.changedTouches
          output.send
            movex: new noflo.IP 'data', touch.pageX,
              touch: idx
            movey: new noflo.IP 'data', touch.pageY,
              touch: idx
      touchend: (event) ->
        event.preventDefault()
        event.stopPropagation()
        return unless event.changedTouches
        return unless event.changedTouches.length
        for touch, idx in event.changedTouches
          output.send
            end: new noflo.IP 'data', event,
              touch: idx
      ctx: context
    data.el.addEventListener 'touchstart', data.touchstart, false
    data.el.addEventListener 'touchmove', data.touchmove, false
    data.el.addEventListener 'touchend', data.touchend, false
    c.elements.push data
    return
