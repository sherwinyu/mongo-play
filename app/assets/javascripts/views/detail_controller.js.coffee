# TODO(syu): naming still subject to change...

Sysys.DetailController = Ember.Object.extend
  enableLogging: true
  stateManager: null
  activeHumonNodeView: (->
    @get('activeHumonNode.nodeView')
  ).property 'activeHumonNode'
  activeHumonNode: null

  commitAndContinue: ->
    ahn = @get('activeHumonNode')
    parent = ahn.get('nodeParent')
    idx = parent.get('nodeVal').indexOf(ahn) + 1
    nextBlank = (Sysys.j2hn "")
    unless ahn.get('nodeParent.isList')
      nextBlank.set 'nodeKey', ''
    Ember.run =>
      parent.replaceAt(idx, 0, nextBlank)
    @commitChanges()
    @activateNode nextBlank
    @focusActiveNodeView()

  # commits the key changes
  # commits the val changes
  commitChanges: ->
    @commitKey()
    @commitVal()

  commitKey: ->
    rawString = @get('activeHumonNodeView').$('> span > .content-field.key')?.first()?.val()
    if rawString?
      # TODO(syu): validate whether rawString can be a key
      @set('activeHumonNode.nodeKey', rawString)
    # TODO(syu): refresh key field

  # precondition: activeNode is a literal
  # does jsonparsing of current activeHumonNodeView content-field.literal
  # calls replaceWithJson on activeNode
  commitVal: ->
    Em.assert 'activeHumonNode needs to be a literal to commitChanges', @get('activeHumonNode.isLiteral')
    rawString = @get('activeHumonNodeView').$('> span > .content-field.val-field')?.first()?.val()
    if rawString?
      json = JSON.parse rawString
      Ember.run =>
        @get('activeHumonNode').replaceWithJson json
    # TODO(syu): refresh val field

  cancelChanges: ->
    Em.assert 'activeHumonNode needs to be a literal', @get('activeHumonNode.isLiteral')
    rawString = @get('activeHumonNode.json')
    @get('activeHumonNodeView').$('> span > .content-field.literal').first().val rawString
    # @get('activeHumonNodeView').$('.content-field').trigger 'focusOut' # TODO(syu): use a generic thirdperson "unfocus" command?

  unfocus: ->
    @get('activeHumonNodeView').$('input').blur()
    @get('activeHumonNodeView').$('textarea').blur()

  focusActiveNodeView: ->
    ahn = @get('activeHumonNode')
    ahnv = @get('activeHumonNodeView')
    nodeKey = ahn.get('nodeKey')
    nodeVal = ahn.get('nodeVal')

    # if there's a key and it's blank
    if nodeKey? && nodeKey == ''
      @focusKeyField()

    # if it's a collection
    if nodeKey? && ahn.get('isCollection')
      @focusKeyField()

    # if it's a 
    if nodeKey? && nodeKey != ''
      @focusValField()

    if !nodeKey?
      @focusValField()

  focusKeyField: ->
    $kf = @get('activeHumonNodeView').$('> span > .content-field.key-field').first()
    $kf.focus()
    unless $kf.length
      $idxf = @get('activeHumonNodeView').$('> span > .content-field.idx-field').first()
      $idxf.focus()

  focusValField: ->
    $vf = @get('activeHumonNodeView').$('> span >  .content-field.val-field').first()
    $vf.focus()

  # sets activeHumonNode to node if node exists
  activateNode: (node, {focus} = {focus: false}) ->
    if node
      @set 'activeHumonNode', node
      if focus
        @focusActiveNodeView()

  nextNode: ->
    newNode = @get('activeHumonNode').nextNode()
    @activateNode newNode, focus: true

  prevNode: ->
    newNode = @get('activeHumonNode').prevNode()
    @activateNode newNode, focus: true

  #TODO(syu): test me
  forceHash: ->
    ahn = @get('activeHumonNode')
    if ahn.get('isCollection') && ahn.get('isList')
      ahn.convertToHash()
    if ahn.get('isLiteral') && ahn.get('nodeParent.isList')
      ahn.get('nodeParent')?.convertToHash()

  #TODO(syu): test me
  forceList: ->
    ahn = @get('activeHumonNode')
    if ahn.get('isCollection') && ahn.get('isHash')
      ahn.convertToList()
    if ahn.get('isLiteral') && ahn.get('nodeParent.isHash')
      ahn.get('nodeParent')?.convertToList()
      
      

  init: ->
    stateMgr = Ember.StateManager.create
      initialState: 'inactive'

      inactive: Ember.State.create
        enter: -> console.log 'entering state inactive'
        exit: -> console.log 'exiting state inactive'

      active: Ember.State.create
        enter: -> console.log 'entering state active'
        exit: -> console.log 'exiting state active'

        editing: Ember.State.create
          enter: -> console.log 'entering state editing'
          exit: -> console.log 'exiting state editing'

          select: (mgr, newNode) ->
            # currentNode.commit()
            # updateNew currentNode to newNode
            # can't call commit bc can have selects that don't commit!

    @set('stateManager', stateMgr)
