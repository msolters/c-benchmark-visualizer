Template.controls.events
  'click button[data-close-port]': ->
    Meteor.call "closeSerialPort", (err, resp) ->
      connected.set false
  ###
  'click button[data-open-port]': ->
    Meteor.call "openSerialPort", (err, resp) ->
  ###
  'click button[data-clear-data]': ->
    Meteor.call "clearAllData", (err, resp) ->
      measurements.clear()
      labels.clear()
      mxm = 0
