window.infection = window.infection || {}

class infection.Level_2_energy extends infection.Level
  constructor: (game) ->
    super(game)

    infection.NODE_CANCER_RATE = 0.0
    infection.EDGE_SPEED = 2
    infection.ENERGY_REDUCTION_RATE = 0.1

    for node in [
        {x: 200, y: 200, size: 30}
        {x: 800, y: 600, size: 100}
        {x: 800, y: 400, size: 50}
      ]
      node = new infection.Node(node.x, node.y, node.size)
      @game.addChild(node)
      @game.nodes.push(node)
      node.init()

    user = new infection.User("rgb(255, 0, 0)")
    @game.users.push(user)

    @game.nodes[0].infect(user)
