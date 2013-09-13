noflow = require 'noflo'

class ReadGamepad extends noflo.Component
  description: "read the state of a gamepad"
  constructor: ->
    @lastTimestamp
    @inPorts =
      gamepad: new noflo.Port 'integer'
    @outPorts =
      out: new noflow.Port 'object'
      error: new noflow.Port 'string'

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
        msg = "state for gamepad '{@gamepad}' could not been read"
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
