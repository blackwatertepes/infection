window.infection = window.infection || {}

class infection.Edge extends infection.Container
  constructor: (start_node, end_node, traj = null) ->
    super
    @start_node = start_node
    @end_node = end_node
    @traj = traj
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
    @bg.graphics.clear().beginStroke('rgba(255, 255, 255, .01)').moveTo(@start.x, @start.y).lineTo(@end.x, @end.y)
    if @path
      toX = @start.x + (@end.x - @start.x) * @percentageComplete()
      toY = @start.y + (@end.y - @start.y) * @percentageComplete()
      @path.graphics.clear().beginStroke('rgba(255, 0, 0, .8)').moveTo(@start.x, @start.y).lineTo(toX, toY)

  beginJourney: ->
    @path = new createjs.Shape()
    @addChild(@path)
    @int = setInterval @travel, 20

  travel: =>
    if !@start_node.dead && @distance_traveled < @distance && @start_node.hasEnergy()
      # Traveling
      @distance_traveled += infection.EDGE_SPEED
      @start_node.reduceEnergy()
    else
      if @distance_traveled >= @distance
        @connected = true
        @end_node.infect()
      clearInterval(@int)

  percentageComplete: ->
    @distance_traveled / @distance
