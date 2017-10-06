noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Listen for user\'s microphone and recognize phrases'
  c.icon = 'microphone'
  c.inPorts.add 'start',
    datatype: 'bang'
    description: 'Start listening for hash changes'
  c.inPorts.add 'stop',
    datatype: 'bang'
    description: 'Stop listening for hash changes'
  c.outPorts.add 'result',
    datatype: 'string'
  c.outPorts.add 'error',
    datatype: 'object'
  c.subscriber = null
  unsubscribe = ->
    return unless c.subscriber
    do c.subscriber.recognition.stop
    do c.subscriber.ctx.deactivate
    c.subscriber = null
  c.tearDown = (callback) ->
    do unsubscribe
    do callback
  c.process (input, output, context) ->
    if input.hasData 'start'
      input.getData 'start'
      # Ensure previous subscription is ended
      do unsubscribe
      unless window.webkitSpeechRecognition
        output.done new Error 'Speech recognition support not available'
        return
      c.subscriber =
        sent: []
        callback: (event) ->
          for result, idx in event.results
            continue unless result.isFinal
            if c.subscriber.sent.indexOf(idx) isnt -1
              continue
            output.send
              result: result[0].transcript
            c.subscriber.sent.push idx
        error: (err) ->
          output.send
            error: err
        ctx: context
      c.subscriber.recognition = new window.webkitSpeechRecognition
      c.subscriber.recognition.continuous = true
      c.subscriber.recognition.start()
      c.subscriber.recognition.onresult = c.subscriber.callback
      c.subscriber.recognition.onerror = c.subscriber.error
      return
    if input.hasData 'stop'
      input.getData 'stop'
      do unsubscribe
      output.done()
      return
