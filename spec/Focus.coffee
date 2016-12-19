noflo = require 'noflo'
socket = noflo.internalSocket
baseDir = 'noflo-interaction'

describe 'Focus component', ->
  c = null
  element = null
  trigger = null
  out = null

  beforeEach (done) ->
    @timeout 4000
    loader = new noflo.ComponentLoader baseDir
    loader.load 'interaction/Focus', (err, instance) ->
      return done err if err
      c = instance
      element = socket.createSocket()
      trigger = socket.createSocket()
      out = socket.createSocket()

      c.inPorts.element.attach element
      c.inPorts.trigger.attach trigger
      c.outPorts.out.attach out
      done()

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

