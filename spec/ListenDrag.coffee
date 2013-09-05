listenDrag = require 'noflo-interaction/components/ListenDrag.js'
socket = require('noflo').internalSocket

describe 'ListenDrag component', ->
  c = null
  element = null
  start = null
  movex = null
  movey = null
  end = null
  beforeEach ->
    c = listenDrag.getComponent()
    element = socket.createSocket()
    start = socket.createSocket()
    movex = socket.createSocket()
    movey = socket.createSocket()
    end = socket.createSocket()
    c.inPorts.element.attach element
    c.outPorts.start.attach start
    c.outPorts.movex.attach movex
    c.outPorts.movey.attach movey
    c.outPorts.end.attach end

  describe 'on matched element', ->
    el = document.querySelector '#fixtures .listendrag .target'
    it 'should transmit a start event on drag start', (done) ->
      element.send el
      start.once 'data', (data) ->
        chai.expect(data).is.instanceof UIEvent
        done()
      evt = document.createEvent 'UIEvent'
      evt.initUIEvent 'dragstart', true, true, window, 1
      evt.clientX = 5
      evt.clientY = 10
      el.dispatchEvent evt

    it 'should transmit a movex event on drag move', (done) ->
      element.send el
      movex.once 'data', (data) ->
        chai.expect(data).to.equal 5
        done()
      evt = document.createEvent 'UIEvent'
      evt.initUIEvent 'drag', true, true, window, 1
      evt.clientX = 5
      evt.clientY = 10
      el.dispatchEvent evt

    it 'should transmit a movey event on drag move', (done) ->
      element.send el
      movey.once 'data', (data) ->
        chai.expect(data).to.equal 10
        done()
      evt = document.createEvent 'UIEvent'
      evt.initUIEvent 'drag', true, true, window, 1
      evt.clientX = 5
      evt.clientY = 10
      el.dispatchEvent evt

    it 'should transmit a end event on drag end', (done) ->
      element.send el
      end.once 'data', (data) ->
        chai.expect(data).is.instanceof UIEvent
        done()
      evt = document.createEvent 'UIEvent'
      evt.initUIEvent 'dragend', true, true, window, 1
      evt.clientX = 5
      evt.clientY = 10
      el.dispatchEvent evt
