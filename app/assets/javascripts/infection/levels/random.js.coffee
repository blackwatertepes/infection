window.infection = window.infection || {}

class infection.Level_0_random extends infection.Level
  constructor: (game) ->
    super(game)

    for node in [0..10]
      size = 20 + Math.random() * 20
      x = Math.random() * (@game.stage.width() - size * 2) + size
      y = Math.random() * (@game.stage.height() - size * 2) + size
      node = new infection.Node(x, y, size)
      @game.addChild(node)
      @game.nodes.push(node)
      node.init()

    for color in ["rgb(255, 0, 0)", "rgb(0, 128, 128)"]
      user = new infection.User(color)
      @game.users.push(user)

    @game.nodes[0].infect(@game.users[0])
    @game.nodes[1].infect(@game.users[1])
