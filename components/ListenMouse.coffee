noflo = require 'noflo'

class ListenMouse extends noflo.Component
  description: 'Listen to mouse events on a DOM element'
  constructor: ->
    @inPorts =
      element: new noflo.Port 'object'
    @outPorts =
      click: new noflo.ArrayPort 'object'
      dblclick: new noflo.ArrayPort 'object'

    @inPorts.element.on 'data', (element) =>
      @subscribe element

  subscribe: (element) ->
    element.addEventListener 'click', @click, false
    element.addEventListener 'dblclick', @dblclick, false

  click: (event) =>
    return unless @outPorts.click.sockets.length
    event.preventDefault()
    event.stopPropagation()

    @outPorts.click.send event
    @outPorts.click.disconnect()

  dblclick: (event) =>
    return unless @outPorts.dblclick.sockets.length
    event.preventDefault()
    event.stopPropagation()

    @outPorts.dblclick.send event
    @outPorts.dblclick.disconnect()

exports.getComponent = -> new ListenMouse
