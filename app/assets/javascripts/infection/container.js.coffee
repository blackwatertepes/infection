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

  bringToTop: (obj) ->
    top = @children[0]
    for child in @children
      if @getChildIndex(child) > @getChildIndex(top)
        top = child
    @swapChildren(top, obj)
