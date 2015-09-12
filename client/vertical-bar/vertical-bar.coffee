Template.verticalBar.rendered = ->
  @vbar = $ @find '.vbar'
  @autorun =>
    data = Template.currentData()
    height = 100 * data.value / data.total
    @vbar.css
      height: "#{height}%"
