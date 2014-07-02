#= require_self
#= require ./key_field
#= require ./index_field
#= require ./title_field

Sysys.ContentEditableField = Ember.View.extend
  tagName: "node-field"
  rawValueBinding: null
  classNames: ['content-field']
  readOnlyBinding: null
  contenteditable: (->
    if @get('readOnly')
      'false'
    else
      'true'
  ).property('readOnly')

  # By default, this content field will have leading and trailing spaces
  # Right now, this is ALWAYS true
  embeddedInText: true

  tabindex: '0'
  attributeBindings: ["contenteditable:contenteditable",  'tabindex:tabindex']
  classNameBindings: ['embeddedInText:embedded-in-text:standalone']

  # Shim for editing or setting the field, jQuery style.
  # Basically just wraps $.text() and $.text(textArg)
  # If an argument is passed, then $.text(textArg) is called
  # Otherwise, $.text() is called and the current text is returned
  val: (args...) ->
    @$().text.apply(@$(), args)

  contentLength: ->
    unescape(@val()).length

  # This exists to prevent propagation to HNV.click, which
  # calls smartFocus
  click: (e) ->
    e.stopPropagation()

  focusIn: (e, args...) ->
    true

  focusOut: (e)->
    true

  didInsertElement: ->
    @refresh()
    @initHotKeys()

  refresh: ->
    @val @get('rawValue')

  initHotKeys: ->
    @createHotKeys()
    for own combo, func of @get 'hotkeys'
      @$().bind 'keydown', combo, func

  createHotKeys: ->
    @set 'hotkeys',
      'return': (e) =>
        e.preventDefault()
        @get('parentView').send 'enterPressed', e
      'down': (e) =>
        e.preventDefault()
        @get('parentView').send 'down', e
      'up': (e) =>
        e.preventDefault()
        @get('parentView').send 'up', e
      'shift+backspace': (e) =>
        e.preventDefault()
        @get('parentView').send 'deletePressed', e

Sysys.ValEditableField = Sysys.ContentEditableField.extend
  classNames: ['val-field']

  initHotKeys: ->
    @_super()
    @$().bind 'keydown', 'left', (e) =>
      @moveLeft(e)

  moveLeft: (e)->
    if getCursor(@$()) ==  0
      @get('parentView').send 'moveLeft'
      e.preventDefault()

  rawValueDidChange: (->
    @refresh()
  ).observes('rawValue')

Sysys.ValEditableTextField = Sysys.ValEditableField.extend
  tagName: 'div'
  classNames: ['val-text-field']

  initHotKeys: ->
    @_super()
    @$().bind 'keydown', 'left', (e) =>
      @moveLeft(e)

  moveLeft: (e)->
    if getCursor(@$()) ==  0
      @get('parentView').send 'moveLeft'
      e.preventDefault()

  rawValueDidChange: (->
    @refresh()
  ).observes('rawValue')
