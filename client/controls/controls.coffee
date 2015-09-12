Template.controls.events
  'click button[data-close-port]': ->
    Meteor.call "closeSerialPort", (err, resp) ->
      connected.set false
  'click button[data-clear-data]': ->
    Meteor.call "clearAllData", (err, resp) ->
      mxm.set 0
      sum.set 0
      benchmarkMsgs.clear()
      benchmarkMsgArray.set []
