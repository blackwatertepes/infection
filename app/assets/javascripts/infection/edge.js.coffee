window.infection = window.infection || {}

class infection.Edge extends infection.Container
  constructor: (start, end, traj = null) ->
    super
    @start = start
    @end = end
    @traj = traj
    @bg = new createjs.Shape()
    @addChild(@bg)
    @path = null
    @distance_traveled = 0
    @connected = false
    if @traj
      @startX = @traj.start().x
      @startY = @traj.start().y
      @endX = @traj.end().x
      @endY = @traj.end().y
    else
      @startX = @start.x
      @startY = @start.y
      @endX = @end.x
      @endY = @end.y
    @distance = Math.sqrt(Math.pow(@startX - @endX, 2) + Math.pow(@startY - @endY, 2))
    @beginJourney()

  draw: ->
    super
    @bg.graphics.clear().beginStroke('rgba(255, 255, 255, .01)').moveTo(@startX, @startY).lineTo(@endX, @endY)
    if @path
      toX = @startX + (@endX - @startX) * @percentageComplete()
      toY = @startY + (@endY - @startY) * @percentageComplete()
      @path.graphics.clear().beginStroke('rgba(255, 0, 0, .8)').moveTo(@startX, @startY).lineTo(toX, toY)

  beginJourney: ->
    @path = new createjs.Shape()
    @addChild(@path)
    @int = setInterval @travel, 20

  travel: =>
    if !@start.dead && @distance_traveled < @distance && @start.hasEnergy()
      # Traveling
      @distance_traveled += infection.EDGE_SPEED #* @start.infection_percentage
      @start.reduceEnergy()
    else
      if @distance_traveled >= @distance
        @connected = true
        @end.infect()
      clearInterval(@int)

  percentageComplete: ->
    @distance_traveled / @distance
