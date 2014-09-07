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
    @end_x = (@start_node.x - x) * 10 + @start_node.x
    @end_y = (@start_node.y - y) * 10 + @start_node.y
    @line.graphics.clear().beginStroke('rgba(255, 255, 255, .1)').moveTo(@start_node.x, @start_node.y).lineTo(@end_x, @end_y)
    if @setTarget()
      orig_distance = Math.sqrt(Math.pow(@start_node.x - @end_x, 2) + Math.pow(@start_node.y - @end_y, 2))
      @distance = Math.sqrt(Math.pow(@start_node.x - @target.x, 2) + Math.pow(@start_node.y - @target.y, 2))
      per = @distance / orig_distance
      dist_x = @start_node.x - @end_x
      dist_y = @start_node.y - @end_y
      @endX = @start_node.x - (dist_x * per)
      @endY = @start_node.y - (dist_y * per)
      @startX = @start_node.x
      @startY = @start_node.y
      start_per = @start_node.size / @distance
      dist_x = @start_node.x - @endX
      dist_y = @start_node.y - @endY
      @startX = @start_node.x - (dist_x * start_per)
      @startY = @start_node.y - (dist_y * start_per)
      @distance = Math.sqrt(Math.pow(@startX - @endX, 2) + Math.pow(@startY - @endY, 2))
      offset = Math.sqrt(Math.pow(@endX - @target.x, 2) + Math.pow(@endY - @target.y, 2))
      end_dist = Math.sqrt(Math.pow(@target.size, 2) - Math.pow((offset), 2))
      end_per = end_dist / @distance
      dist_x = @startX - @endX
      dist_y = @startY - @endY
      @endX = @endX + (dist_x * end_per)
      @endY = @endY + (dist_y * end_per)
      @distance = Math.sqrt(Math.pow(@startX - @endX, 2) + Math.pow(@startY - @endY, 2))
    else
      @distance = null
      @startX = null
      @startY = null
      @endX = null
      @endY = null

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
