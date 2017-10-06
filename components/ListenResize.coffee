noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Listen to window resize events'
  c.icon = 'desktop'
  c.inPorts.add 'start',
    datatype: 'bang'
    description: 'Start listening for screen resizes'
  c.inPorts.add 'stop',
    datatype: 'bang'
    description: 'Stop listening for screen resizes'
  c.outPorts.add 'width',
    datatype: 'number'
  c.outPorts.add 'height',
    datatype: 'number'
  c.subscriber = null
  unsubscribe = ->
    return unless c.subscriber
    window.removeEventListener 'resize', c.subscriber.callback, false
    c.subscriber.ctx.deactivate()
    c.subscriber = null
  c.tearDown = (callback) ->
    do unsubscribe
    do callback
  c.process (input, output, context) ->
    if input.hasData 'start'
      input.getData 'start'
      # Ensure previous subscription is ended
      do unsubscribe
      c.subscriber =
        callback: (event) ->
          output.send
            width: window.innerWidth
            height: window.innerHeight
        ctx: context
      output.send
        width: window.innerWidth
        height: window.innerHeight
      window.addEventListener 'resize', c.subscriber.callback, false
      return
    if input.hasData 'stop'
      input.getData 'stop'
      do unsubscribe
      output.done()
      return
