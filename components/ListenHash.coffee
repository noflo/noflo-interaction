noflo = require 'noflo'

class ListenHash extends noflo.Component
  constructor: ->
    @inPorts =
      start: new noflo.Port 'bang'
      stop: new noflo.Port 'bang'
    @outPorts =
      change: new noflo.Port 'string'

    @inPorts.start.on 'data', =>
      @subscribe()

    @inPorts.stop.on 'data', =>
      @unsubscribe()

  subscribe: ->
    window.addEventListener 'hashchange', @hashChange, false

  unsubscribe: ->
    window.removeEventListener 'hashchange', @hashChange, false
    @outPorts.change.disconnect()

  hashChange: (event) =>
    oldHash = event.oldUrl.split('#')[1]
    newHash = event.newUrl.split('#')[1]
    @outPorts.change.beginGroup oldHash if oldHash
    @outPorts.change.send newHash
    @outPorts.change.endGroup oldHash if oldHash

  shutdown: ->
    @unsubscribe()

exports.getComponent = -> new ListenHash
