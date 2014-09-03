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

    width: ->
      @canvas.width

    height: ->
      @canvas.height

    selectNode: (node) ->
      if @current_node
        # Deselecting infected node
        if @current_node == node
          @deselectCurrentNode()
        # Selecting destination node
        else if !node.infected
          edge = new Edge(@current_node, node)
          @addChild(edge)
          @deselectCurrentNode()
      else if node.infected && !node.dead
        # Selecting infected node
        @current_node = node
        @current_node.select()

    deselectCurrentNode: ->
      @current_node.deselect()
      @current_node = null

  class Node extends createjs.Container
    constructor: (x, y, size) ->
      @initialize()
      @x = x
      @y = y
      @size = size
      @bg = new createjs.Shape()
      @addChild(@bg)
      @infection = null
      @cancer = null
      @infection_percentage = 0
      @cancer_size = 0
      @base_color = 'rgba(255, 255, 255, .5)'
      @selected_color = 'rgba(255, 0, 0, .5)'
      @selected = false
      @infected = false
      @dead = false
      @addListeners()

    draw: ->
      super
      @bg.graphics.clear().beginStroke('white').setStrokeStyle(3).beginFill(@color()).drawCircle(0, 0, @size)
      @infection.graphics.clear().beginFill('rgba(255, 0, 0, .5)').drawCircle(0, 0, @infectionSize()) if @infection
      @cancer.graphics.clear().beginFill('rgba(0, 0, 0, .5)').drawCircle(0, 0, @cancer_size) if @cancer

    addListeners: ->
      @addEventListener('click', @onClick)

    onClick: (e) =>
      @parent.selectNode(@)

    select: ->
      @selected = true

    deselect: ->
      @selected = false

    infect: ->
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
        @dead = true
        clearInterval(@cancer_int)

  class Edge extends createjs.Container
    constructor: (start, end) ->
      @.initialize()
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
        @distance_traveled += EDGE_SPEED * (@start.infection_percentage * EDGE_SPEED_MULTI)
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

  # Add game nodes
  nodes = []
  for node in [0..20]
    size = 10 + Math.random() * 20
    x = Math.random() * (stage.width() - size * 2) + size
    y = Math.random() * (stage.height() - size * 2) + size
    node = new Node(x, y, size)
    stage.addChild(node)
    nodes.push(node)

  createjs.Ticker.addEventListener("tick", stage)

  nodes[0].infect()
