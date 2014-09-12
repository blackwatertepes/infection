window.infection = window.infection || {}

class infection.Line extends createjs.Container
  constructor: (start, end, color, stroke = 1) ->
    @initialize()
    @start = start
    @end = end
    @color = color
    @stroke = stroke
    @bg = new createjs.Shape()
    @addChild(@bg)

  draw: ->
    super
    @bg.graphics.clear().beginStroke(@color).setStrokeStyle(@stroke).moveTo(@start.x, @start.y).lineTo(@end.x, @end.y)

  intersectsLine: (line) ->
    # The point at which the lines would eventually intersect
    x = (@b() - line.b()) / (@m() - line.m())
    y = @m() * x - @b()
    @pointInBounds(-x, -y) && line.pointInBounds(-x, -y)

  pointInBounds: (x, y) ->
    dist_x = Math.abs(@run())
    dist_y = Math.abs(@rise())
    x_within = Math.abs(@start.x - x) < dist_x && Math.abs(@end.x - x) < dist_x
    y_within = Math.abs(@start.y - y) < dist_y && Math.abs(@end.y - y) < dist_y
    x_within && y_within

  rise: ->
    @end.y - @start.y

  run: ->
    @end.x - @start.x

  m: ->
    @rise() / @run()

  b: ->
    @start.y - @start.x / @run() * @rise()

  eq: ->
    "#{@m()}x + #{@b()}"
