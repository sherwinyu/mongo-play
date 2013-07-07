window.HumonTypes =
  _types: {}
  _typeKeys: []

  contextExample:
    name: "string"
    templateName: "humon_node_string"
    # Returns true if the json value could EVER resolve to this type
    # priorities are determined by the order in which types are registered
    # priorities are determined by the order in which types are registered
    typeInferers: ->
    matchAgainstJson: (json) ->
      typeof "json" == "string"

  register: (type, context) ->
    # TODO make warnings about malformed args
    @_types[type] = context
    @_typeKeys.splice 0, 0, type

  contextualize: (type) ->
    if type.constructor == Sysys.HumonTypesNode
      type = type.get('nodeType')
    @_types[type] || Em.assert("Could not find type #{type}")

  resolveType: (json) ->
    for type in @_typeKeys
      if HumonTypes._types[type].matchAgainstJson json
        return type
    if Sysys.HumonUtils.isNumber json
      return "number"
    if Sysys.HumonUtils.isBoolean(json)
      return "boolean"
    if Sysys.HumonUtils.isNull(json)
      return "null"
    if Sysys.HumonUtils.isString(json)
      return "string"
    Em.assert "unrecognized type for json2humonNode: #{json}", false

HumonTypes.register "number",
  name: "number"
  templateName: "humon_node_number"
  matchAgainstJson: (json) ->
    typeof json == "number"
  hn2j: (node) ->
    node
  j2hn: (json) ->
    json

HumonTypes.register "null",
  name: "null"
  templateName: "humon_node_null"
  matchAgainstJson: (json) ->
    json == null
  hn2j: (node) ->
    node
  j2hn: (json) ->
    json

HumonTypes.register "boolean",
  name: "boolean"
  templateName: "humon_node_boolean"
  matchAgainstJson: (json) ->
    typeof json == "boolean"
  hn2j: (node) ->
    node
  j2hn: (json) ->
    json

HumonTypes.register "string",
  name: "string"
  templateName: "humon_node_string"
  matchAgainstJson: (json) ->
    typeof json == "string"
  hn2j: (node) ->
    node
  j2hn: (json) ->
    json

HumonTypes.register "date",
  name: "date"
  templateName: "humon_node_date"
  _dateMatchers: [
    /^now$/,
    /^tomorrow$/,
    /^tmrw$/,
  ]
  _matchesAsStringDate: (json) ->
    return false if json.constructor != String
    @_dateMatchers.some (dateMatcher) -> dateMatcher.test json
  matchAgainstJson: (json) ->
    ret = false
    try
      ret ||= (typeof json is "object" && json.constructor == Date)
      ret ||= @_matchesAsStringDate json

      # if it's an ISO date
      ret ||= (new Date(json.substring 0, 19)).toISOString().substring( 0, 19) == json.substring(0, 19)
    catch error
      console.log error.toString()
      ret = false
    finally
      !!ret
  hn2j: (node) ->
    node.toString() #TODO(syu): can we just keep this a node? Will the .ajax call serialize it properly?
  j2hn: (json) ->
    # TODO(syu): make it work for dateMatchers
    val =
      if json instanceof Date
        json
      else
        new Date(json)
