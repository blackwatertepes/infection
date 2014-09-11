window.infection = window.infection || {}

class infection.Game extends infection.Container
  constructor: (stage) ->
    super
    @stage = stage
    @btn = new createjs.Shape()
    @btn.graphics.beginFill('rgba(0, 0, 0, .05)').drawRect(0, 0, @stage.width(), @stage.height())
    @addChild(@btn)
    @nodes = []
    @edges = []
    for node in [0..10]
      size = 20 + Math.random() * 20
      x = Math.random() * (stage.width() - size * 2) + size
      y = Math.random() * (stage.height() - size * 2) + size
      node = new infection.Node(x, y, size)
      @addChild(node)
      @nodes.push(node)

    users = []
    for color in ["rgb(255, 0, 0)", "rgb(0, 128, 128)"]
      user = new infection.User(color)
      users.push(user)
      
    @nodes[0].infect(users[0])
    @nodes[1].infect(users[1])

    @stage.addChild(@)
    @stage.game = @

    @currentNode = null

    # @addEventListener('click', @onClickHandler)

  onClickHandler: (e) =>
    node = new infection.Node(@stageX(), @stageY(), 10)
    @addChild(node)

    if @currentNode
      edge = new infection.Edge(@currentNode, node)
      @addEdge(edge)
      @currentNode = null
    else
      @currentNode = node

  addEdge: (edge) ->
    @edges.push(edge)
    @addChild(edge)

  getNodesOnLine: (sx, sy, ex, ey) ->
    nodes = []
    for node in @nodes
      if (node.intersectsLine(sx, sy, ex, ey))
        nodes.push(node)
    nodes

  getIntersectingLines: (edge) ->
    edges = []
    for ed in @edges
      if edge.intersects(ed)
        edges.push(ed)
    edges
