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
    start_per = @start.size / @distance
    dist_x = @start.x - @end.x
    dist_y = @start.y - @end.y
    @startX = @start.x - (dist_x * start_per)
    @startY = @start.y - (dist_y * start_per)
    @distance = Math.sqrt(Math.pow(@startX - @end.x, 2) + Math.pow(@startY - @end.y, 2))
    end_per = @end.size / @distance
    dist_x = @startX - @end.x
    dist_y = @startY - @end.y
    @endX = @end.x + (dist_x * end_per)
    @endY = @end.y + (dist_y * end_per)
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
