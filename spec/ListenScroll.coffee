noflo = require 'noflo'
socket = noflo.internalSocket
baseDir = 'noflo-interaction'

describe 'ListenScroll component', ->
  c = null
  start = null
  top = null
  left = null
  origTop = window.scrollY
  origLeft = window.scrollX
  beforeEach (done) ->
    @timeout 4000
    loader = new noflo.ComponentLoader baseDir
    loader.load 'interaction/ListenScroll', (err, instance) ->
      return done err if err
      c = instance
      start = socket.createSocket()
      top = socket.createSocket()
      left = socket.createSocket()
      c.inPorts.start.attach start
      c.outPorts.top.attach top
      c.outPorts.left.attach left
      done()

  afterEach ->
    window.scrollTo origLeft, origTop

  describe 'when started', ->
    it 'should send the new scroll coordinates', (done) ->
      unless window.navigator.userAgent.indexOf('Phantom') is -1
        # Scroll API doesn't seem to work in the PhantomJS test runner
        return @skip()
      if window.location.href is 'http://127.0.0.1:9999/spec/runner.html'
        # Scroll API doesn't seem to work in the SauceLabs test runner
        return @skip()

      start.send true
      top.once 'data', (data) ->
        chai.expect(data).to.equal 10
      left.once 'data', (data) ->
        chai.expect(data).to.equal 0
      top.once 'disconnect', ->
        done()
      window.scrollTo 0, 10
