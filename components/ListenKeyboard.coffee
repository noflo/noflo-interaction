noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Listen for key presses on a given DOM element'
  c.icon = 'keyboard-o'
  c.inPorts.add 'element',
    datatype: 'object'
  c.inPorts.add 'stop',
    datatype: 'object'
  c.outPorts.add 'keypress',
    datatype: 'integer'
  c.elements = []
  unsubcribe = (element) ->
    element.el.removeEventListener 'keypress', element.listener, false
    element.ctx.deactivate()
  c.tearDown = (callback) ->
    unsubscribe element for element in elements
    c.elements = []
    do callback
  c.process (input, output, context) ->
    if input.hasData 'element'
      data =
        el: input.getData 'element'
        listener: (event) ->
          output.send
            keypress: event.keyCode
        ctx: context
      data.el.addEventListener 'keypress', data.listener, false
      c.elements.push data
      return
    if input.hasData 'stop'
      element = input.getData 'stop'
      ctx = null
      for el in c.elements
        continue unless el.el is element
        ctx = el
      return unless ctx
      unsubscribe ctx
      output.done()
