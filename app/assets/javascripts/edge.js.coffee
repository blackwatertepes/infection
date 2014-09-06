window.infection = window.infection || {}

class infection.Edge extends infection.Container
  constructor: (start, end) ->
    super
    @start = start
    @end = end
    @bg = new createjs.Shape()
    @addChild(@bg)
    @path = null
    @distance = Math.sqrt(Math.pow(@start.x - @end.x, 2) + Math.pow(@start.y - @end.y, 2))
    @distance_traveled = 0
    @connected = false
    @beginJourney()

  draw: ->
    super
    @bg.graphics.clear().beginStroke('rgba(255, 255, 255, .5)').moveTo(@start.x, @start.y).lineTo(@end.x, @end.y)
    if @path
      toX = @start.x + (@end.x - @start.x) * @percentageComplete()
      toY = @start.y + (@end.y - @start.y) * @percentageComplete()
      @path.graphics.clear().beginStroke('rgba(255, 0, 0, .8)').moveTo(@start.x, @start.y).lineTo(toX, toY)

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
