###
#     Template.visualizer
###
Template.visualizer.created = ->
  #
  # (1) Check if a serial port is already open.
  #
  Meteor.call "checkIfPortIsOpen", (err, resp) ->
    meteorMethodCB err, resp
    if resp.success
      connected.set resp.connected
      paused.set !resp.connected
    else
      connected.set false
      paused.set true
  Streamy.on 'benchmarkMsg', (d, s) ->
    #
    # (1) Add new data to dictionary.
    #
    benchmarkMsgs.set d.label,
      order: d.order
      t: d.t
    #
    # (2) Sort new data into ordered array.
    #
    _msgs = []
    _sum = 0
    for label, data of benchmarkMsgs.all()
      _sum += data.t
      _msgs.push
        label: label
        order: data.order
        t: data.t
    benchmarkMsgArray.set _.sortBy _msgs, (n) ->
      n.order
    sum.set _sum
    #
    # (3) Update maximum
    #
    mxm.set Math.max(mxm.get(), _sum)


Template.visualizer.helpers
  benchmarkMsgs: ->
    benchmarkMsgArray.get()
  mxm: ->
    mxm.get()
  sum: =>
    sum.get()


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
