window.infection = window.infection || {}

class infection.Trajectory extends infection.Container
  constructor: (start_node) ->
    super
    @start_node = start_node
    @start = @start_node
    @end = {x: 0, y: 0}
    @distance = 0
    @target = null
    @line = new createjs.Shape()
    @addChild(@line)

  update: (x, y) ->
    @end = {x: (@start_node.x - x) * 10 + @start_node.x, y: (@start_node.y - y) * 10 + @start_node.y}
    @line.graphics.clear().beginStroke('rgba(255, 255, 255, .1)').moveTo(@start_node.x, @start_node.y).lineTo(@end.x, @end.y)
    if @setTarget()
      @distance = @dist(@start_node, @target)
      @end = @point_on_line(@start_node, {x: @end.x, y: @end.y}, @distance)
      @start = @point_on_line(@end, @start, @distance - @start_node.size)
      @distance = @dist(@start, @end)
      offset = @dist(@end, @target)
      end_dist = Math.sqrt(Math.pow(@target.size, 2) - Math.pow((offset), 2))
      @end = @point_on_line(@start, @end, @distance - end_dist)
      @distance = @dist(@start, @end)
    else
      @start = @start_node

  setTarget: ->
    @target = null
    nodes = @game().getNodesOnLine(@start_node.x, @start_node.y, @end.x, @end.y)
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

  dist: (start, end) ->
    Math.sqrt(Math.pow(start.x - end.x, 2) + Math.pow(start.y - end.y, 2))

  point_on_line: (start, end, dist) ->
    total_distance = @dist(start, end)
    per = dist / total_distance
    dist_x = start.x - end.x
    dist_y = start.y - end.y
    {x: start.x - (dist_x * per), y: start.y - (dist_y * per)}
