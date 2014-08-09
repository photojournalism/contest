# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

updateCategoryDescription = (name, description) ->
  categoryDescription = $("#category-description")
  categoryDescription.hide()
  $("#category-description-title").html(name)
  $("#category-description-description").html(description)
  categoryDescription.fadeIn(400)

ready = ->
  $("#category-select").change ->
    selected = $("#category-select option:selected")

    id = $(this).val()
    name = selected.text()
    description = selected.attr("data-category-description")
    updateCategoryDescription(name, description)
    

$(document).ready(ready)