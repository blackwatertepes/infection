window.infection = window.infection || {}

class infection.Node extends infection.Container
  constructor: (x, y, size) ->
    super
    @x = x
    @y = y
    @size = size
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
    @bg = new infection.Circle(0, 0, @size, @base_color, @base_stroke, 3)
    @addChild(@bg)
    @btn = new createjs.Shape()
    @addChild(@btn)

  draw: ->
    super
    @btn.graphics.clear().beginFill('rgba(0, 0, 0, .01)').drawCircle(0, 0, @size)
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
    @energy = @size
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
    if @cancer_size < @size
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

  intersectsEdge: (start, end) ->
    @distFromLine(start, end) < @size

  distFromLine: (start, end) ->
    dist_from_start = @distFromPoint(start.x, start.y)
    line_length = Math.sqrt(Math.pow(start.x - end.x, 2) + Math.pow(start.y - end.y, 2))
    dist_per = dist_from_start / line_length
    dist_x = (end.x - start.x) * dist_per
    dist_y = (end.y - start.y) * dist_per
    mx = start.x + dist_x
    my = start.y + dist_y
    @distFromPoint(mx, my)

  distFromPoint: (x, y) ->
    Math.sqrt(Math.pow(x - @x, 2) + Math.pow(y - @y, 2))
