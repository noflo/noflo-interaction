listenTouch = require 'noflo-interaction/components/ListenTouch.js'
socket = require('noflo').internalSocket

describe 'ListenTouch component', ->
  c = null
  element = null
  start = null
  movex = null
  movey = null
  end = null
  beforeEach ->
    c = listenTouch.getComponent()
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
    el = document.querySelector '#fixtures .listentouch .target'
    it 'should transmit a start event on touch start', (done) ->
      element.send el
      start.once 'data', (data) ->
        chai.expect(data).is.instanceof UIEvent
        done()
      evt = document.createEvent 'UIEvent'
      evt.initUIEvent 'touchstart', true, true
      evt.changedTouches = []
      evt.changedTouches.push
        pageX: 5
        pageY: 10
      el.dispatchEvent evt

    it 'should transmit a movex event on touch move', (done) ->
      element.send el
      movex.once 'data', (data) ->
        chai.expect(data).to.equal 5
        done()
      evt = document.createEvent 'UIEvent'
      evt.initUIEvent 'touchmove', true, true
      evt.changedTouches = []
      evt.changedTouches.push
        pageX: 5
        pageY: 10
      el.dispatchEvent evt

    it 'should transmit a movey event on touch move', (done) ->
      element.send el
      movey.once 'data', (data) ->
        chai.expect(data).to.equal 10
        done()
      evt = document.createEvent 'UIEvent'
      evt.initUIEvent 'touchmove', true, true
      evt.changedTouches = []
      evt.changedTouches.push
        pageX: 5
        pageY: 10
      el.dispatchEvent evt

    it 'should transmit a end event on touch end', (done) ->
      element.send el
      end.once 'data', (data) ->
        chai.expect(data).is.instanceof UIEvent
        done()
      evt = document.createEvent 'UIEvent'
      evt.initUIEvent 'touchend', true, true
      evt.changedTouches = []
      evt.changedTouches.push
        pageX: 5
        pageY: 10
      el.dispatchEvent evt
