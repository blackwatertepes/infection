window.infection = window.infection || {}

class infection.Level_1_intro extends infection.Level
  constructor: (game) ->
    super(game)

    infection.NODE_CANCER_RATE = 0
    infection.EDGE_SPEED = 2
    infection.ENERGY_REDUCTION_RATE = 0.1

    for node in [
        {x: 300, y: 300, size: 100}
        {x: 700, y: 500, size: 100}
      ]
      node = new infection.Node(node.x, node.y, node.size)
      @game.addChild(node)
      @game.nodes.push(node)
      node.init()

    user = new infection.User("rgb(255, 0, 0)")
    @game.users.push(user)

    @game.nodes[0].infect(user)
