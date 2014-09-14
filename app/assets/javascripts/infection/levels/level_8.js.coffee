window.infection = window.infection || {}

class infection.Level_8_the_drain extends infection.Level
  constructor: (game) ->
    super(game)

    infection.NODE_CANCER_RATE = 0.05
    infection.EDGE_SPEED = 1.5
    infection.ENERGY_REDUCTION_RATE = 0.1

    for node in [
        {x: 200, y: 300, size: 100}
        {x: 800, y: 200, size: 50}
        {x: 900, y: 600, size: 50}
      ]
      node = new infection.Node(node.x, node.y, node.size)
      @game.addChild(node)
      @game.nodes.push(node)
      node.init()

    for color in ["rgb(255, 0, 0)", "rgb(0, 128, 128)"]
      user = new infection.User(color)
      @game.users.push(user)

    @game.nodes[0].infect(@game.users[0])
    @game.nodes[1].infect(@game.users[1])
