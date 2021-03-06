# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
#  article rating
  $(document).unbind "ajaxSuccess"
  $(document).bind "ajaxSuccess", "rateArticleForm", (event, xhr, settings) ->
#    $("#rating").text(xhr.responseText)
    $("#rateArticleForm").find(":submit").removeClass("disabled")
    $("#articleRatingDiv").prepend('<div class="fade-away"><div data-alert class="alert-box success">
      Thank you for your rating.
      </div></div>')
    $(".fade-away").fadeOut(5000)
    return
  $(document).unbind "ajax:beforeSend"
  $(document).bind "ajax:beforeSend", "rateArticleForm", (event, xhr, settings) ->
    $("#rateArticleForm").find(":submit").addClass("disabled")
    return

  $(document).unbind "ajaxError"
  $(document).bind "ajaxError", "rateArticleForm", (event, xhr, settings) ->
    alert("There has been an error while saving your Article. Please contact the system administrator to inform him of that error.")
    $("#rateArticleForm").find(":submit").removeClass("disabled")
    return

#  comment rating
  $(".commentarea").addClass("hidden")

  $(".rating").click (event) ->
    id = $(this).data("commentid")
    $("#commentarea-"+id).toggleClass("hidden")
    $(document).foundation('slider', 'reflow')
    event.preventDefault()
    return

  $(".commentSubmit").click (event) ->
    form = $(this).parent()
    commentId = form.find("#comment_id").attr("value")
    slider = $("#commentRatingSlider-" + commentId)
    rating = slider.attr("data-slider")
    form.find("#comment_rating").val(rating)
    return

  $(document).bind "ajaxSuccess", "rateCommentForm", (event, xhr, settings) ->
#    $("#rating").text(xhr.responseText)
    $(".rateCommentForm").find(":submit").removeClass("disabled")
    $(".commentRatingDiv").prepend('<div class="fade-away"><div data-alert class="alert-box success">
          Thank you for your rating of ' + xhr.responseText +
      '.</div></div>')
    $(".fade-away").fadeOut(4000)
    return

  $(document).bind "ajax:beforeSend", "rateCommentForm", (event, xhr, settings) ->
    $(".rateCommentForm").find(":submit").addClass("disabled")
    return

  $(document).bind "ajaxError", "rateArticleForm", (event, xhr, settings) ->
    alert("There has been an error while saving your Article. Please contact the system administrator to inform him of that error.")
    $(".rateCommentForm").find(":submit").removeClass("disabled")
    return

  return

$(document).foundation slider: on_change: ->
  $("#articleRating").val($('#articleRatingSlider').attr('data-slider');)
  return

$(document).ready(ready);
$(document).on('page:load', ready);