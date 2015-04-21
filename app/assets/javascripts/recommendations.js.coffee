# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

initialize_tutorial = () ->
  $("#tutorial-button").click ->
    console.log("Tutorial started by the user.")
    $(document).foundation('joyride', 'start')
    return
  return


$(document).ready initialize_tutorial
$(document).on 'page:load', initialize_tutorial