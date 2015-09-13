@connected = new ReactiveVar false
@paused = new ReactiveVar true
@mxm = new ReactiveVar 0
@sum = new ReactiveVar 0
@benchmarkMsgs = new ReactiveMap()
@benchmarkMsgArray = new ReactiveVar 0

Template.registerHelper 'connected', ->
  connected.get()
Template.registerHelper 'paused', ->
  paused.get()
Template.registerHelper 'isData', ->
  window.benchmarkMsgArray.get().length

@meteorMethodCB = (err, resp) ->
  if err?
    Materialize.toast resp.msg, 4500, "red"
  else
    if resp.success
      Materialize.toast resp.msg, 4500, "white black-text"
    else
      Materialize.toast resp.msg, 4500, "red"
