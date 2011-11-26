window.sidebarTweets = class sidebarTweets
  constructor: ->
    @initTweets()

  initTweets: ->
    $("#tweets").tweet
      username: "rubymn"
      join_text: "auto"
      count: 5
      template: '{text}{time}'
      auto_join_text_default: ""
      auto_join_text_ed: ""
      auto_join_text_ing: ""
      auto_join_text_reply: ""
      auto_join_text_url: ""
      loading_text: "loading tweets..."
