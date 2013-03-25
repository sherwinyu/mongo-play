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
    nextBlank = (Sysys.j2hn " ")
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

    if nodeKey? && nodeKey == ''
      console.log 'focusing key field: key length 0'
      @focusKeyField()

    if nodeKey? && ahn.get('isCollection')
      console.log 'focusing key field: is a collection'
      @focusKeyField()

    if nodeKey? && nodeKey != ''
      console.log 'focusing val field: key already filled'
      @focusValField()

    if !nodeKey?
      console.log 'focusing val field: no key, is list'
      @focusValField()

  focusKeyField: ->
    $kf = @get('activeHumonNodeView').$('> span > .content-field.key-field').first()
    $kf.focus()
  focusValField: ->
    $vf = @get('activeHumonNodeView').$('> span >  .content-field.val-field').first()
    $vf.focus()
    ###
    if $cf.length
      console.log '$cf.val', $cf.val()
      console.log 'ahn.json', @get('activeHumonNode.json')
      e  = jQuery.Event "focus"
      e.eventData = suppress: true
      $cf.trigger e
      ###

  # sets activeHumonNode to node if node exists
  activateNode: (node, {focus} = {focus: false}) ->
    if node
      @set 'activeHumonNode', node
      if focus
        @focusActiveNodeView()

  nextNode: ->
    # @unfocus()
    newNode = @get('activeHumonNode').nextNode()
    @activateNode newNode, focus: true

  prevNode: ->
    # @unfocus()
    newNode = @get('activeHumonNode').prevNode()
    @activateNode newNode, focus: true

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
