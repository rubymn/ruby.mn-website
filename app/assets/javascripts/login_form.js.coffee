window.loginFormEnhancements = class loginFormEnhancements
  constructor: ->
    @initFocusLoginField()

  initFocusLoginField: ->
    $('#login').focus()