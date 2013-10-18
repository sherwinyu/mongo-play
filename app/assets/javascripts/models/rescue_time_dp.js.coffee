Sysys.RescueTimeDp = DS.Model.extend
  time: Sysys.attr('date')

  activities: Sysys.attr()

  displayActivities: (->
   ({
    name: k,
    duration: @displayDuration(v.duration),
    category: v.category}
   ) for k, v of @get('activities')
  ).property 'activities'

  weightedProductivity: (->
    totalLength = 0
    weightedSum = 0
    for name, act of @get('activities')
      totalLength += act.duration
      weightedSum += act.productivity * act.duration
    (weightedSum/totalLength).toFixed 3
  ).property('activities')

  totalDuration: (->
    totalLength = 0
    for name, act of @get('activities')
      totalLength += act.duration
    totalLength
    # moment.duration(totalLength*1000).humanize()
    @displayDuration(totalLength)
  ).property('activities')

  displayDuration: (duration) ->
    fmtStr = "m[m] s[s]"
    ret = moment(1000 * duration).utc().format(fmtStr)
    if duration >= 1000 * 60 * 60
      ret = "1h " + ret
      # fmtStr = "h[h] m[m] s[s]"
      # moment(1000 * duration).utc().format(fmtStr)
    ret

  displayTime: (->
    mmt = moment(@get('time'))
    mmt.format('dddd, MMM D @ ha')
  ).property 'time'

  displayTimeRange: (->
    mmt = moment(@get('time'))
    mmt2 = mmt.add('hours', 1)
    mmt2.format('ha')
  ).property 'time'

  displayTimeRelative: (->
    mmt = moment(@get('time'))
    if Math.abs(mmt.diff(moment(), 'hours')) > 22
      mmt.calendar()
    else
      mmt.fromNow()
  ).property 'time'
