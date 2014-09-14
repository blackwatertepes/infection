window.infection = window.infection || {}

class infection.Circle extends createjs.Container
  constructor: (x, y, radius, color, strokeColor, stroke = 1) ->
    @initialize()
    @x = x
    @y = y
    @radius = radius
    @color = color
    @strokeColor = strokeColor
    @stroke = stroke
    @bg = new createjs.Shape()
    @addChild(@bg)

  draw: ->
    super
    @bg.graphics.clear().beginFill(@color).beginStroke(@strokeColor).setStrokeStyle(@stroke).drawCircle(0, 0, @radius)
