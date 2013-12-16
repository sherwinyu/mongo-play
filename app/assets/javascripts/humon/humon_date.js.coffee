Humon.Date = Humon.Primitive.extend(
  mmt: ->
    # Should we clone this?
    moment(@_value)
)
Humon.Date.reopenClass
  _momentFormatTransforms:
    'ddd MMM D': (string, format) ->
      @_momentFormatAndValidate string, format
    'ddd MMM D YYYY': (string, format)->
      @_momentFormatAndValidate string, format
    'YYYY MM DD': (string, format)->
      @_momentFormatAndValidate string, format
    'YYYY M D': (string, format)->
      @_momentFormatAndValidate string, format
    _momentFormatAndValidate: (string, format) ->
      date = @_momentFormat(string, format).toDate()
      valid = !isNaN(date.getTime()) && moment(date).format(format) == string
      {valid: valid, date: date}
    _momentFormat: (string, format) ->
      mmt = moment(string, format)

  _inferAsMomentFormat: (string) ->
    return false if string.constructor != String
    for format, transform of @_momentFormatTransforms
      {valid, date} = @_momentFormatTransforms[format](string, format)
      if valid
        return date
    false

  _inferAsMomentValidDate: (string) ->
    moment(string).isValid() && moment(string).toDate()

  # _inferFromJson -- attempts to convert a json value to this type
  # @param json json: the candidate json object
  # @return [object]   return: if successful, a value of this type
  #   - matches [boolean]: whether the match was a success
  #   - value [underlying value]:
  #
  # Note: _inferFromJson returns the value if `json` could EVER resolve to this type
  # Multiple types can match against the same json; priority is determined by
  # type registration order (calls to HumonType.register)
  _inferFromJson: (json) ->
    ret =
      matches: false
    try
      ret.value ||= (typeof json is "object" && json.constructor == Date && json)
      ret.value ||= json.constructor == String && @_inferAsMomentFormat(json)
      ret.value ||= json.constructor == String && @_inferAsMomentValidDate(json)
    catch error
      console.error error.toString()
    finally
      if ret.value
        ret.matches = true
      return ret

  # We already know that json contains a valid payload for this value.
  # @param [JSON] json the json value
  # @return [Date] the value to be stored as _value
  valueFromJson: (json) ->
    @_inferFromJson(json).value


  # Precondition: `json` can be parsed as this type. That is, @matchesJson(json) returns true
  # @param json [JSON] the json payload to convert into a Humon.Value instance
  # @param context [JSON]
  #   - node [Humon.Node] the Humon Node instance that will contain the parsed Humon.Value
  # TODO(syu): move default behavior into Humon.Primitive / Humon.whatever
  _j2hnv: (json, context) ->
    value = @valueFromJson(json)
    @_klass().create(_value: value, node: context.node)
  matchesJson: (json) ->
    @_inferFromJson(json).matches
