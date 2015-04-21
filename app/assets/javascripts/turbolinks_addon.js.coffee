startSpinner = () ->
  console.log "started fetching"
  $('html').append('<div id="spinner" class="whirly"></div>')
stopSpinner = () ->
  $('.whirly').remove()
  console.log "stopped fetching"


$(document).on("page:fetch", startSpinner);
$(document).on("page:receive", stopSpinner);

