Store = require 'react/flux/store'
Dispatcher = require 'react/flux/dispatcher'
EventEmitter = require('events').EventEmitter
EventConstants = require 'react/event_constants'

React = require 'react'
update = React.addons.update

class ResolutionsStore extends Store

  _group: (resolutions) ->
    _.groupBy resolutions, (resolution) -> resolution.group

  getState: ->
    resolutions = _.values @resolutionsMap
    ret =
      resolutions: resolutions
      groupedResolutions: @_group resolutions

  resetState: ->
    @resolutionsMap = {}

  payloadHandler: (action) ->
    switch action.actionType
      when EventConstants.RESOLUTIONS_LOAD_DONE
        @resolutionsMap = _.indexBy action.resolutions, 'id'
        @emitChange()
      when EventConstants.RESOLUTION_CREATE_DONE
        @resolutionsMap[action.resolution.id] = action.resolution
        @emitChange()
      when EventConstants.RESOLUTION_UPDATE_DONE
        @resolutionsMap[action.resolution.id] = action.resolution
        @emitChange()
      when EventConstants.RESOLUTION_COMPLETION_CREATE_DONE
        @resolutionsMap[action.resolutionId] = action.resolution
        @emitChange()

module.exports =  new ResolutionsStore(Dispatcher)
