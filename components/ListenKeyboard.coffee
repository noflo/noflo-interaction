noflo = require 'noflo'

class ListenKeyboard extends noflo.Component
  constructor: ->
    @inPorts =
      element: new noflo.Port 'object'
    @outPorts =
      keypress: new noflo.Port 'integer'

    @inPorts.element.on 'data', (element) =>
      @subscribe element

  subscribe: (element) ->
    element.addEventListener 'keypress', @keypress, false

  keypress: (event) =>
    return unless @outPorts.keypress.isAttached()
    event.preventDefault()
    event.stopPropagation()

    @outPorts.keypress.send event
    @outPorts.keypress.disconnect()

exports.getComponent = -> new ListenKeyboard
