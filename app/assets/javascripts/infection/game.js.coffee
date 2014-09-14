window.infection = window.infection || {}

class infection.Game extends infection.Container
  constructor: (stage) ->
    super
    @stage = stage
    @stage.addChild(@)
    @stage.game = @

    @btn = new createjs.Shape()
    @addChild(@btn)
    @nodes = []
    @edges = []
    @users = []

    @level = new infection.Level_2_energy(@)

    @currentNode = null

    # @addEventListener('click', @onClickHandler)

  draw: ->
    super
    @btn.graphics.clear().beginFill('rgba(0, 0, 0, .05)').drawRect(0, 0, @stage.width(), @stage.height())

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

  getNodesOnLine: (line) ->
    nodes = []
    for node in @nodes
      if (node.intersectsEdge(line))
        nodes.push(node)
    nodes

  getIntersectingLines: (edge) ->
    edges = []
    for ed in @edges
      if edge.intersectsEdge(ed)
        edges.push(ed)
    edges
