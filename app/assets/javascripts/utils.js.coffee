angular.module('utils', [])
.filter 'capitalize', ->
   (input) ->
     input.charAt(0).toUpperCase() + input.substring(1)
.filter 'ago', ($filter) ->

  dateFilter = $filter('date');

  appendString = (d, s) ->
    Math.abs(Math.round(d)) + s
 
  (time) ->
    return 'Never' if not time
    originalTime = time
 
    time = time.replace /\.\d+/, ''
    time = time.replace(/-/, '/').replace /-/, '/'
    time = time.replace(/T/, ' ').replace /Z/, ' UTC'
    time = time.replace /([\+\-]\d\d)\:?(\d\d)/, ' $1$2'
    time = new Date time * 1000 || time
 
    now = new Date
    seconds = ((now.getTime() - time) * .001) >> 0
    minutes = seconds / 60
    hours = minutes / 60
    days = hours / 24
    years = days / 365
 
    return seconds < 45 and appendString(seconds, 's') or
      minutes < 45 and appendString(minutes, 'm') or
      hours < 24 and appendString(hours, 'h') or
      dateFilter(originalFilter, 'd MMM')
