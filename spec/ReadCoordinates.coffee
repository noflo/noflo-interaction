noflo = require 'noflo'
socket = noflo.internalSocket
baseDir = 'noflo-interaction'

describe 'ReadCoordinates component', ->
  c = null
  event = null
  screen = null
  client = null
  page = null

  beforeEach (done) ->
    @timeout 4000
    loader = new noflo.ComponentLoader baseDir
    loader.load 'interaction/ReadCoordinates', (err, instance) ->
      return done err if err
      c = instance
      event = socket.createSocket()
      screen = socket.createSocket()
      client = socket.createSocket()
      page = socket.createSocket()
      c.inPorts.event.attach event
      c.outPorts.screen.attach screen
      c.outPorts.client.attach client
      c.outPorts.page.attach page
      done()
  describe 'when receiving an event',
    it 'should send coordinates out', (done) ->
      expected = [
        ['screen', 42, 31]
        ['client', 12, 15]
        ['page', 56, 1]
      ]
      screen.on 'data', (data) ->
        exp = expected.shift()
        chai.expect(exp[0]).to.equal 'screen'
        chai.expect(data.x).to.equal exp[1]
        chai.expect(data.y).to.equal exp[2]
        return done() unless expected.length
      client.on 'data', (data) ->
        exp = expected.shift()
        chai.expect(exp[0]).to.equal 'client'
        chai.expect(data.x).to.equal exp[1]
        chai.expect(data.y).to.equal exp[2]
        return done() unless expected.length
      page.on 'data', (data) ->
        exp = expected.shift()
        chai.expect(exp[0]).to.equal 'page'
        chai.expect(data.x).to.equal exp[1]
        chai.expect(data.y).to.equal exp[2]
        return done() unless expected.length
      event.send
        screenX: expected[0][1]
        screenY: expected[0][2]
        clientX: expected[1][1]
        clientY: expected[1][2]
        pageX: expected[2][1]
        pageY: expected[2][2]
