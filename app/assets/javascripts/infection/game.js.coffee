window.infection = window.infection || {}

class infection.Game extends infection.Container
  constructor: (stage) ->
    super
    @stage = stage
    @nodes = []
    for node in [0..20]
      size = 10 + Math.random() * 20
      x = Math.random() * (stage.width() - size * 2) + size
      y = Math.random() * (stage.height() - size * 2) + size
      node = new infection.Node(x, y, size)
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
