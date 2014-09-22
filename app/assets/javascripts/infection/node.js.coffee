window.infection = window.infection || {}

class infection.Node extends infection.Container
  constructor: (x, y, radius) ->
    super
    @x = x
    @y = y
    @radius = radius
    @energy_sprite = null
    @cancer = null
    @energy = 0
    @cancer_size = 0
    @base_color = 'rgba(255, 255, 255, .5)'
    @base_stroke = 'rgb(255, 255, 255)'
    @selected = false
    @infected = false
    @dead = false
    @traj = null
    @bg = new infection.Circle(0, 0, @radius, @base_color, @base_stroke, 3)
    @addChild(@bg)
    @zone = new createjs.Shape()
    @addChild(@zone)
    @btn = new createjs.Shape()
    @addChild(@btn)

  init: ->
    @line = new infection.Line({x: @x - @radius, y: @y}, {x: @x + @radius, y: @y}, 'rgb(255, 255, 255)')
    # @game().addChild(@line)
    @intersect = new infection.Circle(@x, @y, 5, 'rgb(0, 0, 0)')
    # @game().addChild(@intersect)

  draw: ->
    super
    @btn.graphics.clear().beginFill('rgba(0, 0, 0, .01)').drawCircle(0, 0, @radius)
    @energy_sprite.graphics.clear().beginFill(@energy_color()).drawCircle(0, 0, @energy) if @energy_sprite
    @cancer.graphics.clear().beginFill(@user.dark_color).drawCircle(0, 0, @cancer_size) if @cancer
    @zone.graphics.clear().beginStroke('rgba(255, 255, 255, .2)').drawCircle(0, 0, @zoneRadius()) if @energy_sprite

  addListeners: ->
    @btn.addEventListener('mousedown', @onMouseDown)
    @btn.addEventListener('click', @onClick)

  removeListeners: ->
    @btn.removeEventListener('mousedown', @onMouseDown)
    @btn.removeEventListener('click', @onClick)

  onMouseDown: (e) =>
    @select()
    @btn.addEventListener('mouseout', @onMouseOut)
    @traj = new infection.Trajectory(@)
    @game().addChild(@traj)
    @traj_int = setInterval(@updateTraj, 20)

  onClick: (e) =>
    @fire()

  onMouseOut: (e) =>
    @fire()

  fire: ->
    if @traj.target
      edge = new infection.Edge(@, @traj.target, @traj, @user)
      @game().addEdge(edge)
    @game().removeChild(@traj)
    @btn.removeEventListener('mouseout', @onMouseOut)
    clearInterval(@traj_int)
    @deselect()

  updateTraj: =>
    @traj.update(@stageX(), @stageY())

  select: ->
    @selected = true
    @game().bringToTop(@)
    @btn.scaleX = @getStage().width()
    @btn.scaleY = @getStage().height()

  deselect: ->
    @selected = false
    @btn.scaleX = 1
    @btn.scaleY = 1

  infect: (user) ->
    @user = user
    @energy = @radius
    @addListeners()
    @energy_sprite = new createjs.Shape()
    @addChild(@energy_sprite)
    @infected = true
    @bg.strokeColor = @user.light_color
    @beginDeath()

  energy_color: ->
    if @infected then @user.color else @base_color

  beginDeath: ->
    @cancer = new createjs.Shape()
    @addChild(@cancer)
    @cancer_int = setInterval(@spreadCancer, 20)

  reduceEnergy: ->
    if @energy > @cancer_size && @energy > 1
      @energy -= infection.ENERGY_REDUCTION_RATE
    else
      @kill()

  hasEnergy: ->
    @energy > @cancer_size && @energy > 1

  spreadCancer: =>
    if @cancer_size < @energy
      @cancer_size += infection.NODE_CANCER_RATE
    else
      @kill()
      clearInterval(@cancer_int)

  zoneRadius: ->
    Math.max((@energy - @cancer_size) / (infection.ENERGY_REDUCTION_RATE + infection.NODE_CANCER_RATE), 1)

  kill: ->
    @removeListeners()
    @dead = true

  updateLine: (rise, run) ->
    total = (Math.abs(rise) + Math.abs(run))
    yp = rise / total
    xp = run / total
    @line.start = {x: @x + xp * @radius, y: @y + yp * @radius}
    @line.end = {x: @x - xp * @radius, y: @y - yp * @radius}

  updateIntersect: (line) ->
    point = @line.intersection(line)
    @intersect.x = -point.x
    @intersect.y = -point.y

  intersectsEdge: (line) ->
    @updateLine(line.run(), -line.rise())
    @updateIntersect(line)
    if @intersectInNode() && @intersectTargeted(line)
      @intersect.scaleX = 2
      @intersect.scaleY = 2
      return true
    else
      @intersect.scaleX = 1
      @intersect.scaleY = 1
      return false

  intersectTargeted: (line) ->
    line_dir_x = line.start.x - line.end.x
    line_dir_y = line.start.y - line.end.y
    inter_dir_x = line.start.x - @intersect.x
    inter_dir_y = line.start.y - @intersect.y
    line_dir_x * inter_dir_x > 0 && line_dir_y * inter_dir_y > 0

  intersectInNode: ->
    @distFromPoint(@intersect.x, @intersect.y) < @radius

  distFromPoint: (x, y) ->
    Math.sqrt(Math.pow(x - @x, 2) + Math.pow(y - @y, 2))
