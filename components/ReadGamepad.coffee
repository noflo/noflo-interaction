noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Read the state of a gamepad'
  c.icon = 'gamepad'
  c.inPorts.add 'gamepad',
    datatype: 'integer'
  c.outPorts.add 'out',
    datatype: 'object'
  c.outPorts.add 'error',
    datatype: 'object'
  c.lastTimestamps = {}
  c.tearDown = (callback) ->
    c.lastTimestamps = {}
    do callback
  c.process (input, output) ->
    return unless input.hasData 'gamepad'
    gamepad = input.getData 'gamepad'
    unless navigator.webkitGetGamepads
      output.done new Error "No WebKit Gamepad API available"
      return
    gamepadState = navigator.webkitGetGamepads()[gamepad]
    unless gamepadState
      output.done new Error "Gamepad '#{gamepad}' not available"
    if c.lastTimestamps[gamepad] = gamepadState.timestamp
      # No change
      output.done()
      return
    c.lastTimestamps[gamepad] = gamepadState.timestamp
    output.sendDone
      out: gamepadState
