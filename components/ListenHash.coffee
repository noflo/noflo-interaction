noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Listen for hash changes in browser\'s URL bar'
  c.icon = 'slack'
  c.inPorts.add 'start',
    datatype: 'bang'
    description: 'Start listening for hash changes'
  c.inPorts.add 'stop',
    datatype: 'bang'
    description: 'Stop listening for hash changes'
  c.outPorts.add 'initial',
    datatype: 'string'
  c.outPorts.add 'change',
    datatype: 'string'
  c.current = null
  c.subscriber = null
  unsubscribe = ->
    return unless c.subscriber
    window.removeEventListener 'hashchange', c.subscriber.callback, false
    c.subscriber.ctx.deactivate()
    c.subscriber = null
  c.tearDown = (callback) ->
    c.current = null
    do unsubscribe
    do callback
  c.process (input, output, context) ->
    if input.hasData 'start'
      input.getData 'start'
      # Ensure previous subscription is ended
      do unsubscribe
      sendHash = (port) ->
        oldHash = c.current
        c.current = window.location.href.split('#')[1] or ''
        if oldHash
          output.send
            change: new noflo.IP 'openBracket', oldHash
        payload = {}
        payload[port] = c.current
        output.send payload
        if oldHash
          output.send
            change: new noflo.IP 'closeBracket', oldHash
      c.subscriber =
        callback: (event) ->
          sendHash 'change'
        ctx: context
      # Send initial
      sendHash 'initial'
      window.addEventListener 'hashchange', c.subscriber.callback, false
      return
    if input.hasData 'stop'
      input.getData 'stop'
      do unsubscribe
      output.done()
      return
