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
    # @beginDeath() # TODO: Uncomment

  energy_color: ->
    if @infected then @user.color else @base_color

  beginDeath: ->
    @cancer = new createjs.Shape()
    @addChild(@cancer)
    @cancer_int = setInterval(@spreadCancer, 20)

  reduceEnergy: ->
    # TODO: Create ENERGY_REDUCTION_RATE
    if @energy > @cancer_size
      @energy -= .02
    else
      @silence()

  hasEnergy: ->
    @energy > 1

  spreadCancer: =>
    if @cancer_size < @radius
      @cancer_size += infection.NODE_CANCER_RATE
    else
      @kill()
      clearInterval(@cancer_int)

  kill: ->
    @silence()
    @dead = true

  silence: ->
    @energy = 0
    @removeListeners()

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
    @distFromLine(line) < @radius

  distFromLine: (line) ->
    @distFromPoint(@intersect.x, @intersect.y)

  distFromPoint: (x, y) ->
    Math.sqrt(Math.pow(x - @x, 2) + Math.pow(y - @y, 2))
