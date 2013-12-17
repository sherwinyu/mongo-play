#= require_self
#= require ./humon_number
#= require ./humon_string
#= require ./humon_boolean
#= require ./humon_null
#= require ./humon_date
Humon.Primitive = Humon.BaseHumonValue.extend Humon.HumonValue,
  _value: null
  # TODO(syu): @TRANSITION
  isLiteral: true
  setVal: (val) ->
    @set('_value', val)
    @validateSelf()
  toJson: ->
    @_value
  asString: -> @toJson()

  nextNode: ->

  flatten: ->
    [@node]

  subFieldFocusLost: (e, payload)->
    @get('node').tryToCommit(payload.val)



Humon.Primitive.reopenClass
  _klass: ->
    @
  _name: ->
   Em.String.underscore  @_klass().toString().split(".")[1]

  # @param json A JSON payload to be converted into a Humon.Value instance
  # @param context
  #   - node: the Humon.Node instance that will be wrapping the returned Humon.Value
  _j2hnv: (json, context) ->
    json = @normalizeJson(json, typeName: context?.metatemplate?.name)
    @_klass().create(_value: json, node: context.node)

  ##
  # Does NOT trigger validations
  matchesJson: (json) ->
    typeof json == @_name()

  # @param json A JSON payload to be converted into a Humon.Value instance
  # @param opts
  #   - typeName
  # @return [JSON] properly normalized json that has defaults initialized,
  #   and passes @matchesJson
  normalizeJson: (json, {typeName}={} ) ->
    if typeName?
      Em.assert("context.metatemplate specified but doesn't match this class!", typeName == @_name() )
      if !@matchesJson json
        json = @_coerceToValidJsonInput json
    json = @_initJsonDefaults json

  _initJsonDefaults: (json) ->
    json
