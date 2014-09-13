window.infection = window.infection || {}

class infection.Trajectory extends infection.Container
  constructor: (start_node) ->
    super
    @start_node = start_node
    @start = @start_node
    @end = {x: 0, y: 0}
    @distance = 0
    @target = null
    @bg = new infection.Line(@start_node, @end, 'rgba(255, 255, 255, .1)')
    @addChild(@bg)

  update: (x, y) ->
    @end = @bg.end = {x: (@start_node.x - x) * 10 + @start_node.x, y: (@start_node.y - y) * 10 + @start_node.y}
    if @setTarget()
      @distance = @dist(@start_node, @target)
      @end = @point_on_line(@start_node, {x: @end.x, y: @end.y}, @distance)
      @start = @point_on_line(@end, @start, @distance - @start_node.radius)
      @distance = @dist(@start, @end)
      offset = @dist(@end, @target)
      end_dist = Math.sqrt(Math.pow(@target.radius, 2) - Math.pow((offset), 2))
      @end = @point_on_line(@start, @end, @distance - end_dist)
      @distance = @dist(@start, @end)
    else
      @start = @start_node

  setTarget: ->
    @target = null
    nodes = @game().getNodesOnLine(@bg)
    target_nodes = []
    for node in nodes
      if node != @start_node
        target_nodes.push(node)
    if target_nodes.length > 0
      @target = @getClosestNode(target_nodes)

  # TODO: Calculate with intersect distance, instead of arc distance (angle)

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
