Template.portSelector.created = ->
  @ports = new ReactiveVar []

Template.portSelector.helpers
  ports: ->
    Template.instance().ports.get()

Template.portSelector.events
  'click a[data-refresh-ports]': (event, template) ->
    Materialize.toast "Scanning local serial ports...", 4500, "grey darken-3"
    Meteor.call 'listSerialPorts', (err, resp) =>
      meteorMethodCB err, resp
      template.ports.set resp.ports if !err?
  'click a[data-choose-port]': (event, template) ->
    Meteor.call 'chooseSerialPort', @comName, (err, resp) ->
      #console.log err
      connected.set true
