# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Entries = do($ = jQuery) ->
  
  obj = {}

  _updateCategoryDescription = (name, description, typeDescription) ->
    categoryDescription = $("#category-description")
    categoryDescription.hide()
    $("#category-description-title").html(name)
    $("#category-description-description").html(description)
    $("#category-type-description").html(typeDescription)
    categoryDescription.fadeIn(400)

  obj.init = ->
    $("#category-select").change ->
      selected = $("#category-select option:selected")

      id = $(this).val()
      name = selected.text()
      description = selected.attr("data-category-description")
      typeDescription = selected.attr("data-category-type-description")
      _updateCategoryDescription(name, description, typeDescription)

    $("#entry-continue-button").click ->
        obj.create()
      
  
  obj.create = ->
    orderNumber = $("#entry-order-number")
    if $.trim(orderNumber.val()) != ''
      $.ajax({
        url: '/entries',
        type: 'post',
        data: {
          'entry[category]': $("#category-select").val(),
          'entry[order_number]': orderNumber.val()
        },
        success: (data) ->
          window.location.href = data.url;
        error: (data) ->
          console.log(data.responseJSON.message)
      });
    else
      orderNumber.focus()

  obj

$(document).ready ->
  Entries.init()