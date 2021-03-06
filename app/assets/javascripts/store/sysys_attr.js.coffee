###
Sysys.attr is identical to DS.attr, except when dealing with complex (non literal) values.
DS.attr sets the `isDirty` flag via `didSetProperty` when oldValue != newValue, which is
a comparison based on object identity.

Sysys.attr gets around this by pre-emptively comparing (for equality) oldValue and value, and if they are equal,
setting oldVal to value before sending `didSetProperty` (both
oldValue and value are objects, so this assignments sets the identities to the same)

`hasValue`, `getValue`, and `getDefaultValue` are both helper functions closed in
ember-data

TODO(syu): determine whether using JSON.stringify is safe for an equality comparison
  * e.g., if keys are not stringified in consistent order
###

getDefaultValue = (record, options, key) ->
  if typeof options.defaultValue is "function"
    options.defaultValue()
  else
    options.defaultValue

hasValue = (record, key) ->
  record._attributes.hasOwnProperty(key) or record._inFlightAttributes.hasOwnProperty(key) or record._data.hasOwnProperty(key)

getValue = (record, key) ->
  if record._attributes.hasOwnProperty(key)
    record._attributes[key]
  else if record._inFlightAttributes.hasOwnProperty(key)
    record._inFlightAttributes[key]
  else
    record._data[key]

Sysys.attr = (type, options) ->
  options ||= {}
  meta =
    type: type
    isAttribute: true
    options: options
  Ember.computed( (key, value, oldValue) ->
    currentValue = null
    if arguments.length > 1
      Ember.assert "You may not set `id` as an attribute on your model. Please remove any lines that look like: `id: DS.attr('<type>')` from " + @constructor.toString(), key isnt "id"
      oldVal = @_attributes[key] or @_inFlightAttributes[key] or @_data[key]

      # Compare by equality. If they're the same, then
      #   set the object references to mtatch, so that `didSetProperty` does its thing properly
      if JSON.stringify(oldVal) == JSON.stringify(value)
        oldVal = value
      @send "didSetProperty",
        name: key
        oldValue: oldVal
        value: value

      @_attributes[key] = value
      value
    else if hasValue(@, key)
      getValue @, key
    else
      getDefaultValue @, options, key
  ).property('data').meta(meta)



