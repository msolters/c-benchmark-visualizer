###
#     Template.visualizer
###
Template.visualizer.created = ->
  @subscribe 'BenchmarkMsgs'
  @measurements = new ReactiveMap()
  @labels = new ReactiveMap()

  @max = 0

Template.visualizer.rendered = ->
  #
  # (2) Populate @msgs with the latest data
  #
  initializing = true # to prevent overwhelming data on first boot
  @autorun =>
    observer = BenchmarkMsgs.find( ).observeChanges
      added: (_id, doc) =>
        @labels.set _id,
          label: doc.label
          order: doc.order
      changed: (_id, doc) =>
        @measurements.set _id, doc.t
    initializing = false

Template.visualizer.helpers
  benchMarkData: ->
    #Template.instance().benchMarkData.get()
    #
    # (1) Construct list of messages, compute sum.
    #
    msgs = []
    sum = 0
    for _id, t of Template.instance().measurements.all()
      sum += t
      msgInfo = Template.instance().labels.get(_id)
      msgs.push
        _id: _id
        label: msgInfo.label
        order: msgInfo.order
        t: t
    #
    # (2) Check if sum is a new maximum.
    #
    _max = Template.instance().max
    Template.instance().max = sum if sum > _max
    #
    # (3) Sort messages by order of generation.
    #
    msgs = _.sortBy msgs, (n) -> n.order
    return {
      msgs: msgs
      total: sum
      max: _max
    }


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
