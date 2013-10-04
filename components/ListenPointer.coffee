noflo = require 'noflo'

class ListenPointer extends noflo.Component
  description: 'Listen to pointer events on a DOM element'
  constructor: ->
    @action = 'none'
    @propagate = true
    @elements = []

    @inPorts =
      element: new noflo.Port 'object'
      action: new noflo.Port 'string'
      propagate: new noflo.Port 'boolean'
    @outPorts =
      down: new noflo.Port 'object'
      up: new noflo.Port 'object'
      cancel: new noflo.Port 'object'
      move: new noflo.Port 'object'
      over: new noflo.Port 'object'
      out: new noflo.Port 'object'
      enter: new noflo.Port 'object'
      leave: new noflo.Port 'object'

    @inPorts.element.on 'data', (element) =>
      @subscribe element

    @inPorts.action.on 'data', (@action) =>
    @inPorts.propagate.on 'data', (@propagate) =>

  subscribe: (element) ->
    element.setAttribute 'touch-action', @action

    element.addEventListener 'pointerdown', @pointerDown, false
    element.addEventListener 'pointerup', @pointerUp, false
    element.addEventListener 'pointercancel', @pointerCancel, false
    element.addEventListener 'pointermove', @pointerMove, false
    element.addEventListener 'pointerover', @pointerOver, false
    element.addEventListener 'pointerout', @pointerOut, false
    element.addEventListener 'pointerenter', @pointerEnter, false
    element.addEventListener 'pointerup', @pointerUp, false
    @elements.push element

  unsubscribe: (element) ->
    element.removeAttribute 'touch-action'

    element.removeEventListener 'pointerdown', @pointerDown, false
    element.removeEventListener 'pointerup', @pointerUp, false
    element.removeEventListener 'pointercancel', @pointerCancel, false
    element.removeEventListener 'pointermove', @pointerMove, false
    element.removeEventListener 'pointerover', @pointerOver, false
    element.removeEventListener 'pointerout', @pointerOut, false
    element.removeEventListener 'pointerenter', @pointerEnter, false
    element.removeEventListener 'pointerup', @pointerUp, false
    @elements.splice @elements.indexOf(element), 1

  shutdown: ->
    @unsubscribe element for element in @elements

  pointerDown: (event) =>
    @handle event, 'down'
  pointerUp: (event) =>
    @handle event, 'up'
  pointerCancel: (event) =>
    @handle event, 'cancel'
  pointerMove: (event) =>
    @handle event, 'move'
  pointerOver: (event) =>
    @handle event, 'over'
  pointerOut: (event) =>
    @handle event, 'out'
  pointerEnter: (event) =>
    @handle event, 'enter'
  pointerLeave: (event) =>
    @handle event, 'leave'

  handle: (event, type) ->
    event.preventDefault()
    event.stopPropagation() unless @propagate

    unless @outPorts[type].isAttached()
      return
    @outPorts[type].beginGroup event.pointerId
    @outPorts[type].send event
    @outPorts[type].endGroup()

    # End of interaction, send EOTs
    if type is 'cancel' or type is 'leave'
      for name, port of @outPorts
        continue unless port.isAttached()
        port.disconnect()

exports.getComponent = -> new ListenPointer
