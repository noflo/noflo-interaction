focus = require 'noflo-interaction/components/Focus.js'
socket = require('noflo').internalSocket

describe 'Focus component', ->
  c = null
  element = null
  trigger = null

  beforeEach ->
    c = focus.getComponent()
    element = socket.createSocket()
    trigger = socket.createSocket()

    c.inPorts.element.attach element
    c.inPorts.trigger.attach trigger

  describe 'on trigger', ->
    it 'should be dope', () ->
      input = document.createElement 'input'
      focusCalled = false
      input.focus = callback = -> focusCalled = true

      element.send input

      chai.expect(focusCalled).to.equal false

      trigger.send true

      chai.expect(focusCalled).to.equal true
