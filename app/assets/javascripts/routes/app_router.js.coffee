window.delay_param = 250
slowPromise = ->

  new Ember.RSVP.Promise((resolve) ->
    setTimeout (->
      resolve [
        title: "a"
      ,
        title: "b"
      ,
        title: "c"
      ]
    ), 2500
  )

delayed = (ftn) ->
  Ember.RSVP.Promise (resolve) ->
    setTimeout (->
      resolve ftn.call(null)
    ), window.delay_param
Sysys.Router.map ->
  @resource "sexy_articles"

  @resource "data_point", path: "/data_point/:data_point_id", ->
    @route "new"

  @resource "data_points", path: "/data_points", ->
    @route  "new"

  @resource "rescue_time_dps", path: "/rtdps", ->

  @resource "days", path: "/days", ->

  @resource "day", path: "/days/:day_id", ->

Sysys.SexyArticlesRoute = Ember.Route.extend
  model: slowPromise

Sysys.DaysRoute = Ember.Route.extend
  model: (params) ->
    daysPromise = @get('store').findAll 'day'

  activate: ->
    utils.track("days activate")

Sysys.DayIndexRoute = Ember.Route.extend
  model: (params) ->
    dayPromise = @get('store').find 'day', params.day_id

  activate: ->
    utils.track("day activate")

  actions:
    error: (reason) ->
      console.log(reason)
      @transitionTo 'days'

Sysys.DataPointRoute = Ember.Route.extend
  model: (params)->
   dpPromise = @get('store').find 'data_point', params.data_point_id
  activate: ->
    utils.track("data point activate")

Sysys.DataPointIndexRoute = Ember.Route.extend()

Sysys.DataPointsRoute = Ember.Route.extend
  model: (params)->
    delayed =>
     dpsPromise = @get('store').findAll 'data_point'
  activate: ->
    utils.track("data points activate")

Sysys.RescueTimeDpsRoute = Ember.Route.extend
  model: (params)->
     rtdpPromise = @get('store').findAll 'rescue_time_dp'
  activate: ->
    utils.track("rescue time dps activate")

Sysys.RescueTimeDpsIndexRoute = Ember.Route.extend()

Sysys.ApplicationRoute = Ember.Route.extend
  actions:
    jsonChanged: (json)->


    # algorithm:
    #   find all elements with [tabIndex] set
    #   then convert each of those elements to the nearest humon node element
    #   then fire smartFocus on the corresponding humon node view
    downPressed: (e)->
      elements = $('[tabIndex]').closest('.node')
      idx = elements.index($(e.target).closest('.node'))
      return if idx == -1
      idx = (idx + elements.length + 1) % elements.length

      el = elements[idx]
      Sysys.vfi($(el).attr('id')).smartFocus()

    upPressed: (e)->
      elements = $('[tabIndex]').closest('.node')
      idx = elements.index($(e.target).closest('.node'))
      return if idx == -1
      idx = (idx + elements.length - 1) % elements.length

      el = elements[idx]
      Sysys.vfi($(el).attr('id')).smartFocus()

    loading: (transition)->
      resource = transition.targetName.split(".")[0]
      dest = Em.String.classify(resource)
      @controllerFor('loading').set('destination', dest)
      true


Sysys.LoadingRoute = Ember.Route.extend
  beforeModel: (transition) ->

  model: (args...)->

  setupController: (model, controller) ->

Sysys.LoadingController = Ember.ObjectController.extend
  destination: ""
  needs: "application"
