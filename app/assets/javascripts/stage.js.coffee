window.infection = window.infection || {}

class infection.Stage extends createjs.Stage
  constructor: (id) ->
    @initialize(id)
    @enableMouseOver()
    createjs.Ticker.addEventListener("tick", @)

  width: ->
    @canvas.width

  height: ->
    @canvas.height
