window.infection = window.infection || {}

class infection.Container extends createjs.Container
  constructor: ->
    @initialize()

  game: ->
    @getStage().game

  stageX: ->
    @getStage().mouseX

  stageY: ->
    @getStage().mouseY
