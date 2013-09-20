noflo = require 'noflo'

class ListenKeyboard extends noflo.Component
  constructor: ->
    @inPorts =
      element: new noflo.Port 'object'
      stop: new noflo.Port 'bang'
    @outPorts =
      keypress: new noflo.Port 'integer'

    @inPorts.element.on 'data', (element) =>
      @subscribe element

    @inPorts.stop.on 'data', =>
      @unsubscribe()

  subscribe: (element) ->
    element.addEventListener 'keypress', @keypress, false

  unsubscribe: (element) ->
    element.removeEventListener 'keypress', @keypress, false

  keypress: (event) =>
    return unless @outPorts.keypress.isAttached()

    @outPorts.keypress.send event.keyCode
    @outPorts.keypress.disconnect()

  shutdown: ->
    @unsubscribe()

exports.getComponent = -> new ListenKeyboard
