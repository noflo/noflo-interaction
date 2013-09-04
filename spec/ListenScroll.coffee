listenScroll = require 'noflo-interaction/components/ListenScroll.js'
socket = require('noflo').internalSocket

describe 'ListenScroll component', ->
  c = null
  start = null
  top = null
  left = null
  origTop = window.scrollY
  origLeft = window.scrollX
  beforeEach ->
    c = listenScroll.getComponent()
    start = socket.createSocket()
    top = socket.createSocket()
    left = socket.createSocket()
    c.inPorts.start.attach start
    c.outPorts.top.attach top
    c.outPorts.left.attach left

  afterEach ->
    window.scrollTo origLeft, origTop

  describe 'when started', ->
    it 'should send the new scroll coordinates', (done) ->
      unless navigator.userAgent.indexOf('Phantom') is -1
        # Scroll API doesn't seem to work in the PhantomJS test runner
        return done()

      start.send true
      top.once 'data', (data) ->
        chai.expect(data).to.equal 10
      left.once 'data', (data) ->
        chai.expect(data).to.equal 0
      top.once 'disconnect', ->
        done()
      window.scrollTo 0, 10
