# shamelessly stolen from @webandy (Andy Atkinson)
# see http://github.com/webandy/jquery-tweets for a fancy jquery version
window.auto_link_tweet = (tweet) ->
  if (tweet.search(/(https?:\/\/[-\w\.]+:?\/[\w\/_\.]*(\?\S+)?)/) > -1)
    tweet = tweet.replace(/(https?:\/\/[-\w\.]+:?\/[\w\/_\.]*(\?\S+)?)/, "<a href=\"$1\">$1</a>")

  if (tweet.search(/@\w+/) > -1)
    tweet = tweet.replace(/(@)(\w+)/g, "$1<a href=\"http://twitter.com/$2\">$2</a>")

  return tweet

window.relativeTime = (time_value) ->
  values      = time_value.split(' ')
  time_value  = values[1] + " " + values[2] + ", " + values[5] + " " + values[3]
  parsed_date = Date.parse(time_value)

  if arguments.length > 1
    relative_to = arguments[1]
  else
    relative_to = new Date()

  delta = parseInt((relative_to.getTime() - parsed_date) / 1000)
  delta = delta + (relative_to.getTimezoneOffset() * 60)

  r = ''
  if delta < 60
    r = 'a minute ago'
  else if(delta < 120)
    r = 'couple of minutes ago'
  else if(delta < (45 * 60))
    r = (parseInt(delta / 60)).toString() + ' minutes ago'
  else if(delta < (90 * 60))
    r = 'an hour ago'
  else if(delta < (24 * 60 * 60))
    r = '' + (parseInt(delta / 3600)).toString() + ' hours ago'
  else if(delta < (48 * 60 * 60))
    r = '1 day ago'
  else
    r = (parseInt(delta / 86400)).toString() + ' days ago'
  
  return r
# end code from Andy

$ ->
  $(".scroll").on 'click', (e) ->
    e.preventDefault()
    $('html,body').animate { scrollTop: ($('#meeting-info').offset().top - 25) }, 500
