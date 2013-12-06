#= require_self
#= require ./humon_number
#= require ./humon_string
#= require ./humon_boolean
#= require ./humon_null
#= require ./humon_date
Humon.Primitive = Ember.Object.extend Humon.HumonValue,
  _value: null
  # TODO(syu): @TRANSITION
  isLiteral: true
  setVal: (val) ->
    @set('_value', val)
    @validateSelf()
  toJson: ->
    @_value
  asString: ->
    @toJson()
  nextNode: ->
  flatten: ->
    [@node]

Humon.Primitive.reopenClass
  _klass: ->
    @
  _name: ->
    @_klass().toString().split(".")[1].toLowerCase()
  # @param json A JSON payload to be converted into a Humon.Value instance
  # @param context
  #   - node: the Humon.Node instance that will be wrapping the returned Humon.Value
  j2hnv: (json, context) ->
    @_klass().create(_value: json, node: context.node)
  matchesJson: (json) ->
    typeof json == @_name()