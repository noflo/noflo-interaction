noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Listen to scroll events on the browser window'
  c.icon = 'arrows-v'
  c.inPorts.add 'start',
    datatype: 'bang'
    description: 'Start listening for hash changes'
  c.inPorts.add 'stop',
    datatype: 'bang'
    description: 'Stop listening for hash changes'
  c.outPorts.add 'top',
    datatype: 'number'
  c.outPorts.add 'bottom',
    datatype: 'number'
  c.outPorts.add 'left',
    datatype: 'number'
  c.outPorts.add 'right',
    datatype: 'number'
  c.subscriber = null
  unsubscribe = ->
    return unless c.subscriber
    window.removeEventListener 'scroll', c.subscriber.callback, false
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
          top = window.scrollY
          left = window.scrollX
          output.send
            top: top
            bottom: top + window.innerHeight
            left: left
            right: left.window.innerWidth
        ctx: context
      window.addEventListener 'scroll', c.subscriber.callback, false
      return
    if input.hasData 'stop'
      input.getData 'stop'
      do unsubscribe
      output.done()
      return
