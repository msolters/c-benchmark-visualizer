Template.controls.events
  'click button[data-close-port]': ->
    Meteor.call "closeSerialPort", (err, resp) ->
      meteorMethodCB err, resp
      connected.set false if !err?
  'click button[data-clear-data]': ->
    Meteor.call "clearAllData", (err, resp) ->
      try
        mxm.set 0
        sum.set 0
        benchmarkMsgs.clear()
        benchmarkMsgArray.set []
        Materialize.toast "Successfully cleared local data.", 4500, "green"
      catch error
        Materialize.toast "An error occurred while trying to clear local data: #{error}", 4500, "red"
