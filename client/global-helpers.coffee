Template.registerHelper 'connected', ->
  connected.get()
Template.registerHelper 'isData', ->
  BenchmarkMsgs.find().count()
