# TODOS

# Improve grahics/animations
# Add line intersections
# Create tutorials

$ ->
  infection.NODE_CANCER_RATE = parseFloat($('input[name=NODE_CANCER_RATE]').val(), 10)
  infection.EDGE_SPEED = parseFloat($('input[name=EDGE_SPEED]').val(), 10)

  stage = new infection.Stage("board")

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

  game = new infection.Game(stage)
