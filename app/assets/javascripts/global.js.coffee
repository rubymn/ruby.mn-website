$ ->
  window.sidebarTweets = new sidebarTweets()

  $(".scroll").on 'click', (e) ->
    e.preventDefault()
    $('html,body').animate { scrollTop: ($('#meeting-info').offset().top - 25) }, 500
