noflo = require 'noflo'

# @runtime noflo-browser

class Focus extends noflo.Component
  description: 'focus element'
  element: null
  constructor: ->
    super

    @inPorts.add 'element',
      datatype: 'all'
      description: 'element to be focused'
    , (event, payload) =>
      if event is 'data'
        @element = payload

    @inPorts.add 'trigger',
      datatype: 'bang'
      description: 'trigger focus'
    , (event, payload) =>
      if event is 'data'
        window.setTimeout =>
          @element.focus()
          @outPorts.out.send payload
        , 0

    @outPorts.add 'out'

exports.getComponent = -> new Focus

