// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function() {
  $('#map').hide();
  $('#hide_map').live('click', function(){
    $('#map').hide(); 
  })
  $('#view_map').click(function(e) {
    e.preventDefault();
    var link = $(this);
    $.get(link.attr('href'), function(data) {
      data += "<a href='#' id='hide_map'>Hide Map</a>";
      $('#map').html(data).fadeIn().show();
    });
  });
});