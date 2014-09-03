# TODOS

# Edge speed should decrease when number of traveling edges increases
# Create tutorials

$ ->
  NODE_INFECTION_RATE = parseFloat($('input[name=NODE_INFECTION_RATE]').val(), 10)
  NODE_CANCER_RATE = parseFloat($('input[name=NODE_CANCER_RATE]').val(), 10)
  NODE_INFECTION_REDUCTION = parseFloat($('input[name=NODE_INFECTION_REDUCTION]').val(), 10)
  EDGE_SPEED = parseFloat($('input[name=EDGE_SPEED]').val(), 10)
  EDGE_SPEED_MULTI = parseFloat($('input[name=EDGE_SPEED_MULTI]').val(), 10)

  class Stage extends createjs.Stage
    constructor: (id) ->
      @initialize(id)
      @enableMouseOver()
      createjs.Ticker.addEventListener("tick", @)

    width: ->
      @canvas.width

    height: ->
      @canvas.height

  class Game extends createjs.Container
    constructor: (stage) ->
      @initialize()
      @stage = stage
      @nodes = []
      for node in [0..20]
        size = 10 + Math.random() * 20
        x = Math.random() * (stage.width() - size * 2) + size
        y = Math.random() * (stage.height() - size * 2) + size
        node = new Node(x, y, size)
        @addChild(node)
        @nodes.push(node)

      @nodes[0].infect()
      @stage.addChild(@)
      @stage.game = @

    getNodesOnLine: (sx, sy, ex, ey) ->
      nodes = []
      for node in @nodes
        if (node.intersectsLine(sx, sy, ex, ey))
          nodes.push(node)
      nodes

  class Node extends createjs.Container
    constructor: (x, y, size) ->
      @initialize()
      @x = x
      @y = y
      @size = size
      @bg = new createjs.Shape()
      @addChild(@bg)
      @btn = new createjs.Shape()
      @btn.graphics.beginFill('rgba(0, 0, 0, .01)').drawCircle(0, 0, @size)
      @addChild(@btn)
      @infection = null
      @cancer = null
      @infection_percentage = 0
      @cancer_size = 0
      @base_color = 'rgba(255, 255, 255, .5)'
      @selected_color = 'rgba(255, 0, 0, .5)'
      @selected = false
      @infected = false
      @dead = false
      @traj = null

    draw: ->
      super
      @bg.graphics.clear().beginStroke('white').setStrokeStyle(3).beginFill(@color()).drawCircle(0, 0, @size)
      @infection.graphics.clear().beginFill('rgba(255, 0, 0, .5)').drawCircle(0, 0, @infectionSize()) if @infection
      @cancer.graphics.clear().beginFill('rgba(0, 0, 0, .5)').drawCircle(0, 0, @cancer_size) if @cancer

    addListeners: ->
      @btn.addEventListener('mousedown', @onMouseDown)
      @btn.addEventListener('click', @onClick)

    removeListeners: ->
      @btn.removeEventListener('mousedown', @onMouseDown)
      @btn.removeEventListener('click', @onClick)

    onMouseDown: (e) =>
      @select()
      @btn.addEventListener('mouseout', @onMouseOut)
      @traj = new Trajectory(@)
      @getStage().addChild(@traj)
      @traj_int = setInterval(@updateTraj, 20)

    onClick: (e) =>
      @fire()

    onMouseOut: (e) =>
      @fire()

    fire: ->
      if @traj.target
        edge = new Edge(@, @traj.target)
        @getStage().game.addChild(edge)
      @getStage().removeChild(@traj)
      @btn.removeEventListener('mouseout', @onMouseOut)
      clearInterval(@traj_int)
      @deselect()

    updateTraj: =>
      @traj.update(@getStage().mouseX, @getStage().mouseY)

    select: ->
      @selected = true

    deselect: ->
      @selected = false

    infect: ->
      @addListeners()
      @infection = new createjs.Shape()
      @addChild(@infection)
      @infection_int = setInterval(@spreadInfection, 20)
      @infected = true
      @beginDeath()

    spreadInfection: =>
      if @infection_percentage < 1
        @infection_percentage += NODE_INFECTION_RATE

    reduceInfection: ->
      @infection_percentage -= NODE_INFECTION_REDUCTION / @size
      @infection_percentage = 0 if @infection_percentage < 0

    infectionSize: ->
      @infection_percentage * @size

    color: ->
      if @selected then @selected_color else @base_color

    beginDeath: ->
      @cancer = new createjs.Shape()
      @addChild(@cancer)
      @cancer_int = setInterval(@spreadCancer, 20)

    spreadCancer: =>
      if @cancer_size < @size
        @cancer_size += NODE_CANCER_RATE
      else
        @kill()
        clearInterval(@cancer_int)

    kill: ->
      @removeListeners()
      @dead = true

    intersectsLine: (sx, sy, ex, ey) ->
      @distFromLine(sx, sy, ex, ey) < @size

    distFromLine: (sx, sy, ex, ey) ->
      dist_from_start = @distFromPoint(sx, sy)
      line_length = Math.sqrt(Math.pow(sx - ex, 2) + Math.pow(sy - ey, 2))
      dist_per = dist_from_start / line_length
      dist_x = (ex - sx) * dist_per
      dist_y = (ey - sy) * dist_per
      mx = sx + dist_x
      my = sy + dist_y
      @distFromPoint(mx, my)

    distFromPoint: (x, y) ->
      Math.sqrt(Math.pow(x - @x, 2) + Math.pow(y - @y, 2))

  class Trajectory extends createjs.Shape
    constructor: (start_node) ->
      @initialize()
      @start_node = start_node
      @end_x = 0
      @end_y = 0
      @target = null

    update: (x, y) ->
      @end_x = (@start_node.x - x) * 100 + @start_node.x
      @end_y = (@start_node.y - y) * 100 + @start_node.y
      @graphics.clear().beginStroke('rgba(255, 255, 255, .1)').moveTo(@start_node.x, @start_node.y).lineTo(@end_x, @end_y)
      @setTarget()

    setTarget: ->
      @target = null
      nodes = @getStage().game.getNodesOnLine(@start_node.x, @start_node.y, @end_x, @end_y)
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

  class Edge extends createjs.Container
    constructor: (start, end) ->
      @initialize()
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
      @start.reduceInfection()
      @int = setInterval @travel, 20

    travel: =>
      # Dead
      if @start.dead
        clearInterval(@int)
      else if @distance_traveled < @distance
        # Traveling
        # TODO: Remove EDGE SPEED MULTI
        @distance_traveled += EDGE_SPEED #* @start.infection_percentage
      else
        # Done
        @connected = true
        @end.infect()
        clearInterval(@int)

    percentageComplete: ->
      @distance_traveled / @distance

  stage = new Stage("board")

  # Add background
  for spec in [0..100]
    shape = new createjs.Shape()
    exp = 1
    dist = Math.pow(Math.random() * Math.pow(Math.min(stage.width(), stage.height()) / 2, 1 / exp), exp)
    dist_x = Math.random() * dist
    dist_y = Math.sqrt(Math.pow(dist, 2) - Math.pow(dist_x, 2))
    dist_x = dist_x * -1 if Math.random() > .5
    dist_y = dist_y * -1 if Math.random() > .5
    x = stage.width() / 2 + dist_x
    y = stage.height() / 2 + dist_y
    shape.graphics.beginFill('rgba(255, 255, 255, .1)').drawCircle(x, y, 1)
    stage.addChild(shape)

  game = new Game(stage)
