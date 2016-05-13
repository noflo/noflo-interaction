noflo = require 'noflo'

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
        @element.focus()

exports.getComponent = -> new Focus

