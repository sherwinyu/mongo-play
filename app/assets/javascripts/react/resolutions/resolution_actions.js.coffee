Dispatcher = require 'react/flux/dispatcher'
net = require 'utils/net'
EventConstants = require 'react/event_constants'

ResolutionDAO =
  all: ->
    net.getJSON '/resolutions.json'
    .then (response) =>
      response.resolutions = response.resolutions.map (resolution) =>
        @deserializeResolution resolution
      response


  create: (resolution) ->
    net.postJSON
      url: '/resolutions.json'
      data:
        resolution: resolution

  update: (id, resolution) ->
    net.patchJSON
      url: "/resolutions/#{id}.json"
      data:
        resolution: resolution

  addCompletion: (resolutionId, completion) ->
    net.postJSON
      url: "/resolutions/#{resolutionId}/completions.json"
      data:
        completion: @serializeCompletion completion
    .then (response) =>
      response.resolution = @deserializeResolution response.resolution
      response.completion = @deserializeCompletion response.completion
      response

  deserializeResolution: (resolution) ->
    resolution.completions = resolution.completions.map (c) =>
      @deserializeCompletion(c)
    resolution

  serializeCompletion: (completion) ->
    completion.ts = completion.ts?.toJSON()
    completion

  deserializeCompletion: (completion) ->
    completion.ts = moment(completion.ts)
    completion



ResolutionActions =
  loadResolutions: ->
    ResolutionDAO.all()
      .done (response) ->
        Dispatcher.dispatch
          actionType: EventConstants.RESOLUTIONS_LOAD_DONE
          resolutions: response.resolutions

  createResolution: (resolution = {}) ->
    defaults =
      text: 'Untitled resolution'
      type: 'goal'
    resolution = $.extend defaults, resolution
    ResolutionDAO.create resolution
      .done (response) ->
        Dispatcher.dispatch
          actionType: EventConstants.RESOLUTION_CREATE_DONE
          resolution: response.resolution

  updateResolution: (id, resolution) ->
    ResolutionDAO.update id, resolution
      .done (response) ->
        Dispatcher.dispatch
          actionType: EventConstants.RESOLUTION_UPDATE_DONE
          resolutionId: response.resolution.id
          resolution: response.resolution

  createCompletion: (resolutionId, completion) ->
    ResolutionDAO.addCompletion(resolutionId, completion)
      .done (response) ->
        Dispatcher.dispatch
          actionType: EventConstants.RESOLUTION_COMPLETION_CREATE_DONE
          resolutionId: resolutionId
          completion: response.completion
          resolution: response.resolution


module.exports = ResolutionActions
