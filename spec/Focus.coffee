focus = require 'noflo-interaction/components/Focus.js'
socket = require('noflo').internalSocket

describe 'Focus component', ->
  c = null
  element = null
  trigger = null
  out = null

  beforeEach ->
    c = focus.getComponent()
    element = socket.createSocket()
    trigger = socket.createSocket()
    out = socket.createSocket()

    c.inPorts.element.attach element
    c.inPorts.trigger.attach trigger
    c.outPorts.out.attach out

  describe 'on trigger', ->
    it 'should call focus', (done) ->
      input = document.createElement 'input'

      focusCalled = false
      input.focus = callback = -> focusCalled = true
      element.send input

      chai.expect(focusCalled).to.equal false

      out.once 'data', (data) ->
        chai.expect(focusCalled).to.equal true
        done()

      trigger.send true

