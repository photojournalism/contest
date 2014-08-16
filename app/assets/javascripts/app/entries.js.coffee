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

    $("#entry-continue-button").click -> obj.create()
    $("#entry-delete-button").click -> obj.delete()
    $("#entry-save-button").click -> obj.update()
      
  
  obj.create = ->
    orderNumber = $("#entry-order-number")
    if $.trim(orderNumber.val()) != ''
      initLoadingButton("#entry-continue-button")
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
          alert(data.responseJSON.message)
      }).done( ->
        endLoadingButton("#entry-continue-button", 'Continue <i class="glyphicon glyphicon-arrow-right"></i>')
      );
    else
      orderNumber.parent().addClass('has-error')
      orderNumber.focus()

  obj.delete = ->
    hash = $("#entry-hash").html()
    if (confirm('Are you sure you want to delete this entry?'))
      initLoadingButton("#entry-delete-button")
      $.ajax "/entries/#{hash}",
        type: 'delete'
        success: (data) ->
          window.location.href = '/'
        error: (data) ->
          alert(data.responseJSON.message)
      .done( ->
        endLoadingButton("#entry-delete-button", '<i class="glyphicon glyphicon-remove"></i> Delete Entry')
      )

  obj.update = ->
    hash = $("#entry-hash").html()
    url  = $("#entry-url")
    if ($.trim(url.val()) != '')
      initLoadingButton("#entry-save-button")
      $.ajax "/entries/#{hash}",
        type: 'put'
        data: { url: url.val() }
        error: (data) ->
          alert(data.responseJSON.message)
      .done( ->
        endLoadingButton("#entry-save-button", '<i class="glyphicon glyphicon-save"></i> Save Entry')
      )
    else
      url.parent().addClass('has-error')
      url.focus()

  obj

$(document).ready ->
  Entries.init()