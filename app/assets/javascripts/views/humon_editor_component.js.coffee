Sysys.HumonEditorComponent = Ember.Component.extend Sysys.HumonControllerMixin,
  classNames: ['humon-editor']
  hooks: null
  json: {}

  ###
  initialJsonDidChange
  This is to allow this component to bind against deferred value.

  When a HEC is created, the passed-in value for `initialJson` can either be existent
  or undefined.
  If `initialJson` is initialy undefined:
    - we assume that it is a deferred value (actually, an undefined value
      that will become defined when a promise is resolved in the future)
    - we set content and rerender when this observer fires
  If `initialJson` is initially defined:
    - we assume that it's a static (or already resolved) value
    - set content; and the norma view life cycle will render it for us.
  ###
  initialJsonDidChange: (->
    @set 'content', Sysys.j2hn @get 'initialJson'
    @get('childViews')[0].rerender()
  ).observes "initialJson"

  init: ->
    @_super()
    initialJson = @get 'initialJson'
    @set 'content', Sysys.j2hn(initialJson || {})

  # TODO(syu): is this safe? if this object never gets cloned?
  hooks:
    didCommit: (params) ->
      console.log "didCommit:", params, params.payload.key, params.payload.val, JSON.stringify(params.rootJson)
      @sendAction 'jsonChanged', params.rootJson
      @set 'json', params.rootJson

Sysys.HumonEditorView = Ember.View.extend
  templateName: 'humon-editor'
  classNames: ['humon-editor']

  content: null

  init: ->
    Em.assert @get('json')?, "json must be defined for HumonEditorView"

    @set 'content', Sysys.j2hn @get 'json'

    @set 'hooks', $.extend(
      didCommit: (params) =>
        console.log "didCommit:", params, params.payload.key, params.payload.val, JSON.stringify(params.rootJson)
        @set 'json', params.rootJson
    , @get('hooks'))

    detailController = Sysys.DetailController.create
      hooks: @get 'hooks'
      container: Sysys.__container__
      content: @get 'content'

    @set 'controller', detailController
    @_super()

window.appendHev = (selector, initialJson) ->
  @hev = Sysys.HumonEditorView.create
    hooks:
      didUp: ->
        console.log 'didUp'
    json: initialJson
  @hev.appendTo(selector)
  @hev
