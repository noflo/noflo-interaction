noflo = require 'noflo'

class ListenResize extends noflo.Component
  description: 'Listen to window resize events'
  icon: 'desktop'

  constructor: ->
    @inPorts =
      start: new noflo.Port 'bang'
      stop: new noflo.Port 'bang'
    @outPorts =
      initial: new noflo.Port 'object'
      resize: new noflo.Port 'object'

    @inPorts.start.on 'data', =>
      if @outPorts.initial.isAttached()
        @outPorts.initial.send
          width: window.innerWidth
          height: window.innerHeight
        @outPorts.initial.disconnect()
      @subscribe()

    @inPorts.stop.on 'data', =>
      @unsubscribe()

  subscribe: ->
    window.addEventListener 'resize', @resize, false
  unsubscribe: ->
    window.removeEventListener 'resize', @resize, false

  resize: =>
    return unless @outPorts.resize.isAttached()
    @outPorts.resize.send
      width: window.innerWidth
      height: window.innerHeight
    @outPorts.resize.disconnect()

  shutdown: ->
    @unsubscribe()

exports.getComponent = -> new ListenResize
