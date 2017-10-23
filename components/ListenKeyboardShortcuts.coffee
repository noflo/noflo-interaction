noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Listen for keyboard shortcuts and route them'
  c.icon = 'keyboard-o'
  c.inPorts.add 'keys',
    datatype: 'array'
  c.inPorts.add 'ignoreinput',
    datatype: 'boolean'
    default: true
    control: true
  c.inPorts.add 'stop',
    datatype: 'bang'
  c.outPorts.add 'shortcut',
    datatype: 'bang'
    addressable: true
  c.outPorts.add 'missed',
    datatype: 'integer'
  c.subscriber = null
  unsubscribe = ->
    return unless c.subscriber
    document.removeEventListener 'keydown', c.subscriber.callback, false
    c.subscriber.ctx.deactivate()
    c.subscriber = null
  c.tearDown = (callback) ->
    do unsubscribe
    do callback
  c.forwardBrackets = {}
  c.process (input, output, context) ->
    if input.hasData 'keys'
      keys = input.getData 'keys'

      # Ensure previous subscription is ended
      do unsubscribe

      # Older version of this component used string input
      keys = keys.split ',' if typeof keys is 'string'

      # We allow some common keyboard shortcuts to be passed as strings
      for key, index in keys
        switch key
          when '-' then keys[index] = 189
          when '=' then keys[index] = 187
          when '0' then keys[index] = 48
          when 'a' then keys[index] = 65
          when 'x' then keys[index] = 88
          when 'c' then keys[index] = 67
          when 'v' then keys[index] = 86
          when 'z' then keys[index] = 90
          when 'r' then keys[index] = 82

      ignoreInput = if input.hasData('ignoreinput') then input.getData('ignoreinput') else true

      c.subscriber =
        callback: (event) ->
          return unless event.ctrlKey or event.metaKey
          return if event.target.tagName is 'TEXTAREA' and ignoreInput
          return if event.target.tagName is 'INPUT' and ignoreInput
          return if String(event.target.contentEditable) is 'true' and ignoreInput
          route = keys.indexOf event.keyCode
          if route is -1
            output.send
              missed: event.keyCode
            return
          event.preventDefault()
          event.stopPropagation()
          output.send
            shortcut: new noflo.IP 'data', event.keyCode,
              index: route
        ctx: context
      document.addEventListener 'keydown', c.subscriber.callback, false
      return
    if input.hasData 'stop'
      input.getData 'stop'
      do unsubscribe
      output.done()
      return
