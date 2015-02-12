# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $(document).bind "ajaxSuccess", "rateArticleForm", (event, xhr, settings) ->
    alert("Your Rating has been set or updated.")
    $("#rateArticleForm").find(":submit").toggleClass("disabled")

  $(document).bind "ajax:beforeSend", "rateArticleForm", (event, xhr, settings) ->
    $("#articleRating").val($('#articleRatingSlider').attr('data-slider');)
    $("#rateArticleForm").find(":submit").toggleClass("disabled")

  $(document).bind "ajaxError", "rateArticleForm", (event, xhr, settings) ->
    alert("There has been an error while saving your Article. Please contact the system administrator to inform him of that error.")
    $("#rateArticleForm").find(":submit").toggleClass("disabled")

