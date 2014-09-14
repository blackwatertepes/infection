window.infection = window.infection || {}

class infection.Level_3_weak_neighbor extends infection.Level
  constructor: (game) ->
    super(game)

    infection.NODE_CANCER_RATE = 0.0
    infection.EDGE_SPEED = 2
    infection.ENERGY_REDUCTION_RATE = 0.15

    for node in [
        {x: 300, y: 100, size: 55}
        {x: 850, y: 600, size: 65}
        {x: 100, y: 100, size: 35}
      ]
      node = new infection.Node(node.x, node.y, node.size)
      @game.addChild(node)
      @game.nodes.push(node)
      node.init()

    user = new infection.User("rgb(255, 0, 0)")
    @game.users.push(user)

    @game.nodes[0].infect(user)
