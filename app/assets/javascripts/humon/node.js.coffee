Humon.Node = Ember.Object.extend
  nodeVal: null
  nodeType: null
  nodeParent: null
  nodeView: null
  nodeKey: null

  isHashBinding: Ember.Binding.oneWay('nodeVal.isHash')
  isListBinding: Ember.Binding.oneWay('nodeVal.isList')
  isCollectionBinding: Ember.Binding.oneWay('nodeVal.isCollection')
  isLiteralBinding: Ember.Binding.oneWay('nodeVal.isLiteral')
  hasChildrenBinding: Ember.Binding.oneWay('nodeVal.hasChildren')

  flatten: ->
    @get('nodeVal').flatten? && @get('nodeVal').flatten()

  lastFlattenedChild: ->
    Em.assert("Node contains a collection", @get('isCollection'))
    arr = @flatten()
    arr[arr.length - 1]

  nextNode: ->
    throw new Error "Not implemented yet"

  prevNode: ->
    throw new Error "Not implemented yet"

  convertToHash: ->
    throw new Error "Not implemented yet"

  convertToList: ->
    throw new Error "Not implemented yet"

  replaceWithJson: (json) ->
    throw new Error "Not implemented yet"

  replaceWithHumon: (newNode) ->
    throw new Error "Not implemented yet"

  replaceAt: (idx, amt, nodes...) ->
    throw new Error "Not implemented yet"

  insertAt: (idx, nodes...) ->
    throw new Error "Not implemented yet"

  deleteChild: (node) ->
    throw new Error "Not implemented yet"

  pathToNode: (testNode) ->
    throw new Error "Not implemented yet"

  isDescendant: (testNode) ->
    path = @pathToNode(testNode)
    !!path

  unknownProperty: (key) ->
    @get("nodeVal.#{key}") #.get(key)

  toJson: ->
    @get('nodeVal').toJson()

  val: ->
    @get('nodeVal').toJson()

  asString: ->
    @get('nodeVal').asString()
