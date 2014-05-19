noflo = require 'noflo'

class ListenHash extends noflo.Component
  description: 'Listen for hash changes in browser\'s URL bar'
  icon: 'slack'
  constructor: ->
    @current = null
    @inPorts =
      start: new noflo.Port 'bang'
      stop: new noflo.Port 'bang'
    @outPorts =
      initial: new noflo.Port 'string'
      change: new noflo.Port 'string'

    @inPorts.start.on 'data', =>
      @subscribe()

    @inPorts.stop.on 'data', =>
      @unsubscribe()

  subscribe: ->
    @current = @getHash()
    window.addEventListener 'hashchange', @hashChange, false

    if @outPorts.initial.isAttached()
      @outPorts.initial.send @current
      @outPorts.initial.disconnect()

  unsubscribe: ->
    window.removeEventListener 'hashchange', @hashChange, false
    @outPorts.change.disconnect()

  hashChange: (event) =>
    oldHash = @current
    @current = @getHash()
    @outPorts.change.beginGroup oldHash if oldHash
    @outPorts.change.send @current
    @outPorts.change.endGroup oldHash if oldHash

  getHash: -> window.location.hash.substr(1) or ''

  shutdown: ->
    @unsubscribe()

exports.getComponent = -> new ListenHash
