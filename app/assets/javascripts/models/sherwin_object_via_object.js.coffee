contentPropertyWillChange = (content, contentKey) ->
  key = contentKey.slice 8
  if key in @ then return
  Ember.propertyWillChange(@, key)

contentPropertyDidChange = (content, contentKey) ->
  key = contentKey.slice 8
  if key in @ then return
  Ember.propertyDidChange @, key

Sysys.EnumerableObjectViaObject = Ember.Object.extend Ember.Array,
  _keys: null
  content: null

  isHash: true

  nextObject: (indexNumber, previousObject, context) ->
    key = @get('_keys').objectAt(indexNumber)
    @get('content')?.get('key')

  length: (Ember.computed -> @get('_keys.length') ? 0 ).property("_keys.@each")

  init: ->
    initContent = @get('content')
    @set('content', Ember.Object.create())
    @set('_keys', [])
    for k, v of initContent
      @set(k, v)
    @_super

  objectAt: (idx) ->
    unless 0 <= idx < @get('_keys.length')
      return undefined
    key = @get('_keys')[idx]
    @get(key)

  keyForIndex: (idx) ->
    unless 0 <= idx < @get('_keys.length')
      return undefined
    key = @get('_keys')[idx]

  renameKey: (oldKey, newKey) ->
    idx = @_keys.indexOf oldKey
    Ember.assert("Cannot rename key that doesn't exist", idx != -1)
    Ember.assert("Cannot rename to key that already exists", @_keys.indexOf(newKey) == -1)
    # debugger
    # Ember.assert("newKey must be a string", newKey instanceof String)
    val = @content.get oldKey
    @content.set newKey, val
    delete @content[oldKey]
    @_keys[idx] = newKey
    true
    #@_keys.map((i, v) -> v == newKey).without(false).length == 1



  pushObj: (key, val) ->
    @arrayContentWillChange(@get('length'), 0, 1)
    @get('_keys').pushObject key
    @get('content').set(key, val)
    # @arrayContentDidChange(@get('length') - 1,

  _updateObj: (key, val) ->
    @arrayContentWillChange(@get('_keys').indexOf(key), 0, 0)
    @get('content').set(key, val)

  setUnknownProperty: (key, val) ->
    content = @get('content')

    Ember.assert(Ember.String.fmt("Cannot delegate set('%@', %@) to the 'content' property of object proxy %@: its 'content' is undefined.", [key, val, @]), content)

    if content.hasOwnProperty key
      @_updateObj(key, val)
    else
      @pushObj(key, val)
    ###
    unless content.hasOwnProperty key
      @get('_keys').pushObject key
    content.set(key, value)
    ###
    # content.get(key).set('_key', key)
    #return content.get(key)

  unknownProperty: (key) ->
    content = @get('content')
    if content?.hasOwnProperty key
      content.get key
    else
      undefined

  willWatchProperty: (key) ->
    contentKey = 'content.' + key
    Ember.addBeforeObserver(@, contentKey, null, contentPropertyWillChange)
    Ember.addObserver(this, contentKey, null, contentPropertyDidChange)

  didUnwatchProperty: (key) ->
    contentKey = 'content.' + key
    Ember.removeBeforeObserver @, contentKey, null, contentPropertyWillChange
    Ember.removeObserver @, contentKey, null, contentPropertyWillChange

  serialize: ->
    Sysys.JSONWrapper.recursiveSerialize @
