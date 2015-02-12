# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $(document).bind "ajaxSuccess", "rateArticleForm", (event, xhr, settings) ->
    $("#rating").text(xhr.responseText)
    alert("Your Rating has been set or updated.")
    $("#rateArticleForm").find(":submit").toggleClass("disabled")

  $(document).bind "ajax:beforeSend", "rateArticleForm", (event, xhr, settings) ->
    $("#rateArticleForm").find(":submit").toggleClass("disabled")

  $(document).bind "ajaxError", "rateArticleForm", (event, xhr, settings) ->
    alert("There has been an error while saving your Article. Please contact the system administrator to inform him of that error.")
    $("#rateArticleForm").find(":submit").toggleClass("disabled")

$(document).foundation slider: on_change: ->
  $("#articleRating").val($('#articleRatingSlider').attr('data-slider');)
  return
