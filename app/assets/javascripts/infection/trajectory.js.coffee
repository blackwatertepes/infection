window.infection = window.infection || {}

class infection.Trajectory extends infection.Container
  constructor: (start_node) ->
    super
    @start_node = start_node
    @end_x = 0
    @end_y = 0
    @target = null
    @line = new createjs.Shape()
    @addChild(@line)

  update: (x, y) ->
    @end_x = (@start_node.x - x) * 100 + @start_node.x
    @end_y = (@start_node.y - y) * 100 + @start_node.y
    @line.graphics.clear().beginStroke('rgba(255, 255, 255, .1)').moveTo(@start_node.x, @start_node.y).lineTo(@end_x, @end_y)
    if @setTarget()
      @distance = Math.sqrt(Math.pow(@start_node.x - @target.x, 2) + Math.pow(@start_node.y - @target.y, 2))
      start_per = @start_node.size / @distance
      dist_x = @start_node.x - @target.x
      dist_y = @start_node.y - @target.y
      @startX = @start_node.x - (dist_x * start_per)
      @startY = @start_node.y - (dist_y * start_per)
      @distance = Math.sqrt(Math.pow(@startX - @target.x, 2) + Math.pow(@startY - @target.y, 2))
      end_per = @target.size / @distance
      dist_x = @startX - @target.x
      dist_y = @startY - @target.y
      @endX = @target.x + (dist_x * end_per)
      @endY = @target.y + (dist_y * end_per)
      @distance = Math.sqrt(Math.pow(@startX - @endX, 2) + Math.pow(@startY - @endY, 2))

  setTarget: ->
    @target = null
    nodes = @game().getNodesOnLine(@start_node.x, @start_node.y, @end_x, @end_y)
    target_nodes = []
    for node in nodes
      if node != @start_node
        target_nodes.push(node)
    if target_nodes.length > 0
      @target = @getClosestNode(target_nodes)

  getClosestNode: (nodes) ->
    closest = nodes[0]
    for node in nodes
      closest = node if (@getDist(node) < @getDist(closest))
    closest
     
  getDist: (node) -> 
    Math.sqrt(Math.pow(@start_node.x - node.x, 2) + Math.pow(@start_node.y - node.y, 2))

  start: ->
    {x: @startX, y: @startY}

  end: ->
    {x: @endX, y: @endY}
