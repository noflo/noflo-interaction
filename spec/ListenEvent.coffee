noflo = require 'noflo'
socket = noflo.internalSocket
baseDir = 'noflo-interaction'

describe 'ListenEvent component', ->
  c = null
  element = null
  event = null
  out = null
  beforeEach (done) ->
    @timeout 4000
    loader = new noflo.ComponentLoader baseDir
    loader.load 'interaction/ListenEvent', (err, instance) ->
      return done err if err
      c = instance
      element = socket.createSocket()
      event = socket.createSocket()
      out = socket.createSocket()
      c.inPorts.element.attach element
      c.inPorts.event.attach event
      c.outPorts.out.attach out
      done()

  describe 'on matched element', ->
    el = document.querySelector '#fixtures .listenevent .target'
    it 'should transmit a click packet on click event', (done) ->
      element.send el
      event.send 'click'
      out.once 'data', (data) ->
        chai.expect(data).is.instanceof UIEvent
        chai.expect(data.eventName).to.equal 'click'
        done()
      evt = document.createEvent 'UIEvent'
      evt.initUIEvent 'click', true, true, window, 1
      evt.clientX = 5
      evt.clientY = 10
      el.dispatchEvent evt
    it 'should transmit a foo packet on foo event', (done) ->
      element.send el
      event.send 'foo'
      out.once 'data', (data) ->
        chai.expect(data).is.instanceof UIEvent
        chai.expect(data.eventName).to.equal 'foo'
        done()
      evt = document.createEvent 'UIEvent'
      evt.initUIEvent 'foo', true, true, window, 1
      evt.clientX = 5
      evt.clientY = 10
      el.dispatchEvent evt
