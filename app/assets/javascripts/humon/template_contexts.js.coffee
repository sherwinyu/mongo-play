Humon.TemplateContext = Ember.Object.extend
  name: "literal"

  keys: ["asString", "asJson", "iconClass"]
  asString: (node) ->  node.asString()
  asJson: (node) -> node.toJson()

  iconClass: (node) -> "fa-circle-o"
  templateName: (->
    "humon_node_#{@name}"
  ).property('name')

  # @param node  -- the Humon.Node against which to evaluate the template strings
  # @returns An object containing template strings, which node templates can bind
  # against
  materializeTemplateStrings: (node) ->
    materializedStrings = {}
    for key in @keys
      materializedStrings[key] = if typeof @[key] is "function"
                                   @[key].call(@, node)
                                 else
                                   @[key]

    templateStrings = @get('templateStrings')
    # If the registered templateStrings is a function, lazy-evaluate it
    # with the node as the argument
    templateStrings = @templateStrings
    if typeof @templateStrings is "function"
      templateStrings = @templateStrings.call(@, node)
    # Iterate over template strings and evaluate them
    for own k, v of templateStrings
      materializedStrings[k] = if typeof v is "function"
                                 v.call(@, node)
                               else
                                 v

    return materializedStrings


Humon.TemplateContexts = Ember.Namespace.create
  # @param type [string] type name
  register: (type, opts) ->
    baseClass = Humon.TemplateContext
    if opts.extends instanceof Humon.TemplateContext
      baseClass = opts.extends
    Humon.TemplateContexts[type] = baseClass.extend(opts)

Humon.TemplateContexts.register "String",
  iconClass: "fa-quote-left"

Humon.TemplateContexts.register "Number",
  iconClass: "fa-tachometer"

Humon.TemplateContexts.register "Null",
  iconClass: "fa-ban-circle"
  asString: -> "null"

Humon.TemplateContexts.register "Boolean",
  iconClass: "fa-check"

Humon.TemplateContexts.register "List",
  templateName: "humon_node"

Humon.TemplateContexts.register "Date",
  iconClass: "fa-calendar"
  templateName: "humon_node_date"
  templateStrings: (node)->
    date = node.val()
    month:  date.getMonth()
    day:  date.getDay()
    hour:  date.getHours()
    abbreviated:  utils.date.humanized(date)
    asString:  utils.date.asString(date)
    relative:  utils.date.relative(date)
    verbose:  utils.date.verbose(date)

Humon.TemplateContexts.register "Time",
  iconClass: "fa-clock-o"
  templateName: "humon_node_date"
  templateStrings: (node)->
    time = node.val()
    month:  time.getMonth()
    day:  time.getDay()
    hour:  time.getHours()
    abbreviated:  utils.time.humanized(time)
    asString:  utils.time.asString(time)
    relative:  utils.time.relative(time)
    verbose:  utils.time.verbose(time)


Humon.TemplateContexts.Hash = Humon.TemplateContexts.List.extend()
Humon.TemplateContexts.Complex = Humon.TemplateContexts.Hash.extend()
Humon.TemplateContexts.Sleep = Humon.TemplateContexts.Complex.extend(
  templateName: "humon_node_sleep"
)
