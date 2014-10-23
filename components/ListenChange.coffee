noflo = require 'noflo'

class ListenChange extends noflo.Component
  description: 'Listen to mouse events on a DOM element'
  constructor: ->
    @elements = []
    @inPorts =
      element: new noflo.Port 'object'
    @outPorts =
      value: new noflo.ArrayPort 'all'

    @inPorts.element.on 'data', (element) =>
      @subscribe element

  subscribe: (element) ->
    element.addEventListener 'change', @change, false
    @elements.push element

  unsubscribe: ->
    for element in @elements
      element.removeEventListener 'change', @change, false
    @elements = []

  change: (event) =>
    return unless @outPorts.value.sockets.length
    event.preventDefault()
    event.stopPropagation()

    @outPorts.value.send event.target.value
    @outPorts.value.disconnect()

  shutdown: ->
    @unsubscribe()

exports.getComponent = -> new ListenChange
