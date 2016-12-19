noflo = require 'noflo'
socket = noflo.internalSocket
baseDir = 'noflo-interaction'

describe 'ListenMouse component', ->
  c = null
  element = null
  click = null
  beforeEach (done) ->
    @timeout 4000
    loader = new noflo.ComponentLoader baseDir
    loader.load 'interaction/ListenMouse', (err, instance) ->
      return done err if err
      c = instance
      element = socket.createSocket()
      click = socket.createSocket()
      c.inPorts.element.attach element
      c.outPorts.click.attach click
      done()

  describe 'on matched element', ->
    el = document.querySelector '#fixtures .listenmouse .target'
    it 'should transmit a click event on mouse click', (done) ->
      element.send el
      click.once 'data', (data) ->
        chai.expect(data).is.instanceof UIEvent
        done()
      evt = document.createEvent 'UIEvent'
      evt.initUIEvent 'click', true, true, window, 1
      evt.clientX = 5
      evt.clientY = 10
      el.dispatchEvent evt
    it 'should transmit a dblclick event on mouse dblclick', (done) ->
      element.send el
      dblclick = socket.createSocket()
      c.outPorts.dblclick.attach dblclick
      dblclick.once 'data', (data) ->
        chai.expect(data).is.instanceof UIEvent
        done()
      evt = document.createEvent 'UIEvent'
      evt.initUIEvent 'dblclick', true, true, window, 1
      evt.clientX = 5
      evt.clientY = 10
      el.dispatchEvent evt
