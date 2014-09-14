window.infection = window.infection || {}

class infection.Level_6_the_center extends infection.Level
  constructor: (game) ->
    super(game)

    infection.NODE_CANCER_RATE = 0.05
    infection.EDGE_SPEED = 2
    infection.ENERGY_REDUCTION_RATE = 0.15

    for node in [
        {x: 850, y: 600, size: 60}
        {x: 300, y: 200, size: 150}
        {x: 600, y: 600, size: 20}
        {x: 800, y: 200, size: 20}
        {x: 300, y: 500, size: 20}
        {x: 700, y: 300, size: 20}
      ]
      node = new infection.Node(node.x, node.y, node.size)
      @game.addChild(node)
      @game.nodes.push(node)
      node.init()

    user = new infection.User("rgb(255, 0, 0)")
    @game.users.push(user)

    @game.nodes[0].infect(user)
