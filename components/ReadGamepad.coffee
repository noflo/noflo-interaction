noflo = require 'noflo'

class ReadGamepad extends noflo.Component
  description: 'Read the state of a gamepad'
  icon: 'gamepad'
  constructor: ->
    @lastTimestamp
    @inPorts =
      gamepad: new noflo.Port 'int'
    @outPorts =
      out: new noflo.Port 'object'
      error: new noflo.Port 'string'

    @inPorts.gamepad.on 'data', (number) =>
      @readGamepad number

  readGamepad: (number) ->
    if !navigator.webkitGetGamepads
      msg = "no webkit gamepad api available"
      if @outPorts.error.isAttached()
        @outPorts.error.send msg
        @outPorts.error.disconnect()
        return
      else
        throw new Error msg

    gamepadState = navigator.webkitGetGamepads()[number]
    if !gamepadState
      msg = "state for gamepad '#{number}' could not been read"
      if @outPorts.error.isAttached()
        @outPorts.error.send msg
        @outPorts.error.disconnect()
        return
      else
        throw new Error msg

    if @lastTimestamp != gamepadState.timestamp
      @lastTimestamp = gamepadState.timestamp
      @outPorts.out.send gamepadState

exports.getComponent = -> new ReadGamepad
