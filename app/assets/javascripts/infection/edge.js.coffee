window.infection = window.infection || {}

class infection.Edge extends infection.Container
  constructor: (start_node, end_node, traj = null, user = null) ->
    super
    @start_node = start_node
    @end_node = end_node
    @traj = traj
    @user = user
    @pathTo = null
    @pathFrom = null
    @to_distance = 0
    @from_distance = 0
    @connected = false
    if @traj
      @start = @traj.start
      @end = @traj.end
    else
      @start = @start_node
      @end = @end_node
    @bg = new infection.Line(@start, @end, 'rgba(255, 255, 255, .2)')
    @addChild(@bg)
    @distance = Math.sqrt(Math.pow(@start.x - @end.x, 2) + Math.pow(@start.y - @end.y, 2))
    @beginJourney()

  kill: ->
    clearInterval @int

  beginJourney: ->
    @pathTo = new infection.Line(@start, @start, @user.color)
    @addChild(@pathTo)
    if @end_node.user
      @pathFrom = new infection.Line(@end, @end, @end_node.user.color)
      @addChild(@pathFrom)
    @int = setInterval @travel, 20

  travel: =>
    toX = @start.x + (@end.x - @start.x) * @toPercentage()
    toY = @start.y + (@end.y - @start.y) * @toPercentage()
    @pathTo.end = {x: toX, y: toY}
    if @pathFrom
      fromX = @end.x + (@start.x - @end.x) * @fromPercentage()
      fromY = @end.y + (@start.y - @end.y) * @fromPercentage()
      @pathFrom.end = {x: fromX, y: fromY}

    if @intersectingLines().length > 0 || @start_node.dead || @end_node.dead || @to_distance + @from_distance >= @distance
      @kill()
      console.log 'kill'
      return false

    if @start_node.hasEnergy() && @to_distance < @distance - @from_distance && !@end_node.infected
      # Traveling to end
      @to_distance += infection.EDGE_SPEED
      @start_node.reduceEnergy()

    if @end_node.hasEnergy() && @from_distance < @distance - @to_distance && !@start_node.dead
      # Traveling from end
      console.log 'drain'
      @from_distance += infection.EDGE_SPEED
      @end_node.reduceEnergy()
    
    if @to_distance >= @distance
      @connected = true
      @end_node.infect(@user)
  
  toPercentage: ->
    @to_distance / @distance

  fromPercentage: ->
    @from_distance / @distance

  intersectingLines: ->
    @game().getIntersectingLines(@)

  intersectsEdge: (edge) ->
    return false if edge == @
    (edge.pathTo && edge.pathTo.intersectsLine(@bg)) || (edge.pathFrom && edge.pathFrom.intersectsLine(@bg))
