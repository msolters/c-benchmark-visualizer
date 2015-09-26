Template.verticalBar.rendered = ->
  @vbar = $ @find '.vbar'
  @vbarms = $ @find '.vbar-ms'
  @autorun =>
    data = Template.currentData()
    frac = data.value / data.total
    height = 100 * frac
    h = 120 * (1-frac) + 0 * frac
    ###
    ra = 76
    rb = 244
    r = parseInt (ra * (1-frac) + rb * frac )
    ga = 175
    gb = 67
    g = parseInt (ga * (1-frac) + gb * frac )
    ba = 80
    bb = 54
    b = parseInt (ba * (1-frac) + bb * frac )
    ###

    @vbar.css
      height: "#{height}%"
      "background-color": "hsl(#{h}, 100%, 60%)"
    @vbarms.css
      bottom: "#{height}%"
