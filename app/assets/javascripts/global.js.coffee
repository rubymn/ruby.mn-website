$ ->
  window.sidebarTweets = new sidebarTweets()
  window.loginFormEnhancements = new loginFormEnhancements()

  $(".scroll").on 'click', (e) ->
    e.preventDefault()
    $('html,body').animate { scrollTop: ($('#meeting-info').offset().top - 25) }, 500

  $('.register_for_event').on 'click', () ->
    $(@).hide()
    $('.event_registration_form').show()
