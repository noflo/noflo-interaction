noflo = require 'noflo'

class ListenHash extends noflo.Component
  description: 'Listen for hash changes in browser\'s URL bar'
  icon: 'slack'
  constructor: ->
    @current = null
    @inPorts = new noflo.InPorts
      start:
        datatype: 'bang'
        description: 'Start listening for hash changes'
      stop:
        datatype: 'bang'
        description: 'Stop listening for hash changes'
    @outPorts = new noflo.OutPorts
      initial:
        datatype: 'string'
        required: false
      change:
        datatype: 'string'
        required: false

    @inPorts.start.on 'data', =>
      @subscribe()

    @inPorts.stop.on 'data', =>
      @unsubscribe()

  subscribe: ->
    @current = @getHash()
    window.addEventListener 'hashchange', @hashChange, false
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

  getHash: ->
    window.location.href.split('#')[1] or ''

  shutdown: ->
    @unsubscribe()

exports.getComponent = -> new ListenHash
