Sysys.HumonNodeView = Ember.View.extend
  templateName: 'humon_node'
  nodeContentBinding: Ember.Binding.oneWay('controller.content')
  classNameBindings: [
    'nodeContent.isLiteral:node-literal:node-collection',
    'nodeContent.isHash:node-hash',
    'nodeContent.isList:node-list',
    'isActive:active',
    'parentActive:activeChild',
    'suppressGap']
  classNames: ['node']
  focusOut: (e) ->
    console.log ' focusing out '
    e.stopPropagation()
    @losingFocus()

  # focusIn
  #  1) cancels propagation
  #  2) if current HNV is active returns and does nothing
  #     if current HNV is not active,  calls activateNode on the current node content
  #
  #  This is primarily called indirectly by event bubbling from content fields
  focusIn: (e) ->
    console.log 'humon node view focusing in '
    console.log "   currently focused item is", $(':focus')
    e.stopPropagation()
    if @get 'isActive'
      console.log "    canceled because node is already active"
      return
    else
      console.log "    calling transitionToNode"
      @get('controller').activateNode @get('nodeContent')
      # TODO(syu): @get('controller').transitionToNode @get('nodeContent')

  # focusOut
  #   1) constructs a payload to be sent to @controller `commitEverything`
  #   2) payload contains {key, val}
  #   3) key is taken from the key field's value
  #   4) val is taken from the val field TODO(syu): clarify what 'val field' actually means
  focusOut: (e) ->
    e.stopPropagation()
    console.log 'hnv focusing out'
    # TODO(syu):
    # prepare payload: pull from $().val, etc
    # send to `commit`
    node = @get('nodeContent')
    console.log('commitingEverything, node=', node.get('json'))
    console.log('commitingEverything, activeNode =', @get('controller.activeHumonNode.json'))
    payload =
      val: @$valField().val()
      key: @$keyField().val()
    @get('controller').send 'commitEverything', payload

  # smartFocus -- "auto" sets the focus for this HNV based on context
  # contexts used
  #   * Key field empty?
  #   * Val field empty?
  #   * context?
  smartFocus: ->
    node = @get('nodeContent')
    context = node.get('nodeParent.nodeType')
    nodeKey = node.get('nodeKye')
    nodeVal = node.get('nodeVal')
    if context == 'hash'
      @$keyField().focus()
    @$valField().focus()

  # click -- responds to a click event on the HNV
  # primarily for
  #   1) cancels propagation
  #   2) if HNV is already active, just smart focus
  #   3) if HNV is not active, set it as active
  #   4) regardless, call @smartFocus
  click: (e)->
    # TODO(syu): should be
    #   1. trigger 'try to transitionTonode'
    #   2. smartFocus to set the focus
    # @get('controller').activateNode @get('nodeContent'), focus: true
    # e.stopPropagation()
    console.log 'hnv click'
    e.stopPropagation()
    @$().focus() # focusIn()
    ###
    unless @get 'isActive'
      console.log "    attempting to transition to node"
      @get('controller').activateNode @get('nodeContent')
    ###
    console.log '  smart focusing'
    @smartFocus()

  json_string: (->
    JSON.stringify @get('nodeContent.json')
  ).property('nodeContent.json')

  isActive: (->
    ret = @get('controller.activeHumonNode') == @get('nodeContent') && @get('nodeContent')?
  ).property('controller.activeHumonNode', 'nodeContent')

  parentActive: (->
    ret = @get('controller.activeHumonNode') == @get('nodeContent.nodeParent')
  ).property('controller.activeHumonNode', 'nodeContent.nodeParent')

  # normally, there is a 5px gap at the bottom of node-collections to make room for the [ ] and { } glyphs.
  # However, if multiple collections all exit, we don't want a ton of white space, so we only show the gap
  # if this nodeCollection has an additional sibling after it
  suppressGap: (->
    @get('nodeContent.nodeParent.nodeVal.lastObject') == @get('nodeContent')
  ).property('nodeContent.nodeParent.nodeVal.lastObject')

  willDestroyElement: ->
    # @animDestroy()
    @unbindHotkeys()
    @get('nodeContent')?.set 'nodeView', null

  didInsertElement: ->
    # @animInsert()
    @initHotkeys()
    @get('nodeContent')?.set 'nodeView', @

  animInsert: ->
    anims = @get('controller.anims')
    $el = @$()
    if @get('isActive') and anims?.insert
      switch anims['insert']
        when 'slideDown'
          $el.animate bottom: $el.css('height'), 0
          $el.animate bottom: 0, 185
        when 'slideUp'
          $el.css 'z-index', 555
          $el.animate top: $el.css('height'), 0
          $el.animate top: 0, 185, ->
            $el.css 'z-index', ''
        when 'fadeIn'
          $el.hide 0
          $el.fadeIn 185
        when 'appear'
          Em.K
      anims.insert = undefined
      return
    $el.hide 0
    $el.slideDown 375

  animDestroy: ->
    anims = @get('controller.anims')
    $el = @$().clone()
    @.$().replaceWith $el
    if @get('isActive') and anims?.destroy
      switch anims.destroy
        when 'slideDown'
          $el.slideDown 185
        when 'slideUp'
          # $el.animate bottom: $el.css('height'), 185
          $el.slideUp 185
        when 'fadeOut'
          $el.fadeOut 185
        when 'disappear'
          $el.addClass 'tracker'
          $el.hide 0
      anims.destroy = undefined
      delay 185, -> $el.remove()
      return
    console.log 'sliding up'
    $el.slideUp 250, ->
      $el.remove()

  unbindHotkeys: Em.K

  initHotkeys: ->
    @$().bind 'keyup', 'up', (e) =>

  $labelField: ->
    @$('> span> .content-field.label-field')?.first()
  $keyField: ->
    @$('> span > .content-field.key-field')?.first()
  $idxField: ->
    @$('> span > .content-field.idx-field')?.first()
  $valField: ->
    @$('> span > .content-field.val-field')?.first()
  $proxyField: ->
    @$('> span > .content-field.proxy-field')?.first()
  $bigValField: ->
    @$('> .content-field.big-val-field')?.first()

  enterEditing: ->
    Em.assert ' '
    return if @get 'editing'
    console.log 'entering editing'
    x = @$bigValField()
    @set 'editing', true
    @$bigValField().addClass 'editing'
    @$('> .node-item-collection-wrapper').first().addClass 'editing'
    hmn = humon.json2humon @get 'nodeContent.json'
    @$bigValField().val hmn
    x.focus()

  exitEditing:->
    Em.assert ' '
    return unless @get 'editing'
    Em.assert 'must already be editing to exit', @get 'editing'
    console.log 'exiting editing'
    @set('editing', false)
    @$bigValField().removeClass 'editing'
    @$('> .node-item-collection-wrapper').first().removeClass 'editing'
    Em.View.views[ @$bigValField().attr 'id' ].removeAutogrow()
    @get('controller').smartFocus()

  commitAndContinue: ->
    if @$valField().val() == ''
      @$valField().val '{}'
    @get('controller').commitAndContinue( @$valField().val())

Sysys.DetailView = Sysys.HumonNodeView.extend
  init: ->
    Ember.run.sync() # <-- need to do this because nodeContentBinding hasn't propagated yet
    @_super()

  didInsertElement: ->
    Ember.run.sync()
    @_super()

  focusOut: (e) ->
    if @get('controller')
      @get('controller').activateNode null
