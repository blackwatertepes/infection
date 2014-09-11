window.infection = window.infection || {}

class infection.Edge extends infection.Container
  constructor: (start_node, end_node, traj = null, user = null) ->
    super
    @start_node = start_node
    @end_node = end_node
    @traj = traj
    @user = user
    @bg = new createjs.Shape()
    @addChild(@bg)
    @path = null
    @distance_traveled = 0
    @connected = false
    if @traj
      @start = @traj.start
      @end = @traj.end
    else
      @start = @start_node
      @end = @end_node
    @distance = Math.sqrt(Math.pow(@start.x - @end.x, 2) + Math.pow(@start.y - @end.y, 2))
    @beginJourney()

  draw: ->
    super
    @bg.graphics.clear().beginStroke('rgba(255, 255, 255, .1)').moveTo(@start.x, @start.y).lineTo(@end.x, @end.y)
    if @path && @user
      toX = @start.x + (@end.x - @start.x) * @percentageComplete()
      toY = @start.y + (@end.y - @start.y) * @percentageComplete()
      @path.graphics.clear().beginStroke(@user.color).moveTo(@start.x, @start.y).lineTo(toX, toY)

  kill: ->
    clearInterval @int

  beginJourney: ->
    @path = new createjs.Shape()
    @addChild(@path)
    @int = setInterval @travel, 20

  travel: =>
    if !@start_node.dead && @distance_traveled < @distance && @start_node.hasEnergy()
      # Traveling
      @distance_traveled += infection.EDGE_SPEED
      @start_node.reduceEnergy()
      @kill() if @intersectingLines().length > 0
    else
      if @distance_traveled >= @distance
        @connected = true
        @end_node.infect(@user)
      clearInterval(@int)

  percentageComplete: ->
    @distance_traveled / @distance

  intersectingLines: ->
    @game().getIntersectingLines(@)

  intersects: (edge) ->
    return false if edge == @
    # The point at which the lines would eventually intersect
    x = (@b() - edge.b()) / (@m() - edge.m())
    y = @m() * x - @b()
    @pointInBounds(-x, -y) && edge.pointInBounds(-x, -y)

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
