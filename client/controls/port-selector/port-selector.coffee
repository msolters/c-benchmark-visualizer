Template.portSelector.created = ->
  @ports = new ReactiveVar []

Template.portSelector.helpers
  ports: ->
    Template.instance().ports.get()

Template.portSelector.events
  'click a[data-refresh-ports]': (event, template) ->
    Meteor.call 'listSerialPorts', (err, resp) =>
      template.ports.set resp
  'click a[data-choose-port]': (event, template) ->
    Meteor.call 'chooseSerialPort', @comName, (err, resp) ->
      #console.log err
      connected.set true
