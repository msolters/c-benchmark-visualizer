Template.registerHelper 'connected', ->
  connected.get()
Template.registerHelper 'isData', ->
  window.benchmarkMsgArray.get().length

@meteorMethodCB = (err, resp) ->
  if err?
    Materialize.toast resp.msg, 4500, "red"
  else
    if resp.success
      Materialize.toast resp.msg, 4500, "green"
    else
      Materialize.toast resp.msg, 4500, "red"
