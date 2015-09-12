@measurements = new ReactiveMap()
@labels = new ReactiveMap()
@connected = new ReactiveVar false
@mxm = 0

###
#     Template.visualizer
###
Template.visualizer.created = ->
  @subscribe 'BenchmarkMsgs'

Template.visualizer.rendered = ->
  #
  # (1) Check if a serial port is already open.
  #
  Meteor.call "checkIfPortIsOpen", (err, resp) ->
    connected.set resp
  #
  # (2) Populate @msgs with the latest data
  #
  @autorun =>
    observer = BenchmarkMsgs.find( ).observeChanges
      added: (_id, doc) =>
        labels.set _id,
          label: doc.label
          order: doc.order
      changed: (_id, doc) =>
        measurements.set _id, doc.t

Template.visualizer.helpers
  benchMarkData: =>
    #Template.instance().benchMarkData.get()
    #
    # (1) Construct list of messages, compute sum.
    #
    msgs = []
    sum = 0
    for _id, t of measurements.all()
      sum += t unless isNaN t
      msgInfo = labels.get(_id)
      msgs.push
        _id: _id
        label: msgInfo.label
        order: msgInfo.order
        t: t
    #
    # (2) Check if sum is a new mxmimum.
    #
    window.mxm = Math.max(sum, window.mxm)
    #
    # (3) Sort messages by order of generation.
    #
    msgs = _.sortBy msgs, (n) -> n.order
    return {
      msgs: msgs
      total: sum
      max: window.mxm
    }

Template.visualizer.destroyed = ->
  Meteor.call "closeSerialPort"

###
#       Template.axisLabel
###
Template.axisLabel.helpers
  yPos: ->
    height = Template.currentData().fraction * 100
    "#{height}%"
  label: ->
    data = Template.currentData()
    data.total * data.fraction
