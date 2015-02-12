# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $(document).bind "ajaxSuccess", "rateArticleForm", (event, xhr, settings) ->
    $("#rating").text(xhr.responseText)
    $("#rateArticleForm").find(":submit").toggleClass("disabled")
    $("#articleRatingDiv").prepend('<div class="fade-away"><div data-alert class="alert-box success">
      Thank you for your rating.
      </div></div>')
    $(".fade-away").fadeOut(4000)
    return

  $(document).bind "ajax:beforeSend", "rateArticleForm", (event, xhr, settings) ->
    $("#rateArticleForm").find(":submit").toggleClass("disabled")
    return

  $(document).bind "ajaxError", "rateArticleForm", (event, xhr, settings) ->
    alert("There has been an error while saving your Article. Please contact the system administrator to inform him of that error.")
    $("#rateArticleForm").find(":submit").toggleClass("disabled")
    return

$(document).foundation slider: on_change: ->
  $("#articleRating").val($('#articleRatingSlider').attr('data-slider');)
  return
