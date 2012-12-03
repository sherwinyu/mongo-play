Sysys.Action = DS.Model.extend
  description: DS.attr "string"
  duration: DS.attr( "number", defaultValue: 50)
  start_time: DS.attr "date"
  end_time: DS.attr "date"

  start_time_pretty: (->
    debugger
    date = @get('start_time')?.getDay()
    hours = @get('start_time')?.getHours()
    minutes = @get('start_time')?.getMinutes()
    "#{date} #{hours}:#{minutes}"
    ).property('start_time')

    ###
  pretty_date: (date_key) ->
    date = @get('date_key').getDay()
    hours = @get('date_key').getHours()
    minutes = @get('date_key').getMinutes()
    "#{date} #{hours}:#{minutes}"
    ###




  s: (->
    # debugger
      # JSON.stringify(@)
     "desc: #{@get('description')}\t duration: #{@get('duration')}\t start_time: #{@get('start_time')}\t end_time: #{@get('end_time')}"
    ).property('description')




  endTime: (->
    unless @get('startTime')
      return new Date()
    new Date(@get('startTime').getTime() + @get('duration2') * 1000)
  ).property('startTime', 'duration2').cacheable()
  
  isActive: -> 
    current = new Date
    t1 = @get('startTime').getTime()  
    t2 = @get('endTime').getTime()

    return current < new Date(t2)
    
  timeRemainingMs: ->
    if @isActive()
      @get('endTime').getTime() - new Date().getTime()
    else
      0

  timeRemaining: (->
    d = new Date(@timeRemainingMs())
    "#{d.getUTCHours()}:#{d.getUTCMinutes()}:#{d.getUTCSeconds()}.#{d.getUTCMilliseconds()}"
  ).property('startTime', 'duration2').cacheable()


    #to_s: ->
    #JSON.stringify(@)

