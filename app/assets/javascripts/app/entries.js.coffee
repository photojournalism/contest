Entries = do($ = jQuery) ->
  
  obj = {}

  _updateCategoryDescription = () ->
    selected = $("#category-select option:selected")
    name = selected.text()
    description = selected.attr("data-category-description")
    typeDescription = selected.attr("data-category-type-description")

    categoryDescription = $("#category-description")
    categoryDescription.hide()
    $("#category-description-title").html(name)
    $("#category-description-description").html(description)
    $("#category-type-description").html(typeDescription)
    categoryDescription.fadeIn(400)

  obj.init = ->
    _updateCategoryDescription()

    $("#category-select").change ->
      _updateCategoryDescription()

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
    
    submit = (data) ->
      initLoadingButton("#entry-save-button")
      $.ajax "/entries/#{hash}",
        type: 'put'
        data: data
        success: (response) ->
          window.location.href = response.url
        error: (response) ->
          alert(response.responseJSON.message)
      .done( ->
        endLoadingButton("#entry-save-button", '<i class="glyphicon glyphicon-save"></i> Save Entry')
      )

    hash = $("#entry-hash").html()
    url  = $("#entry-url")
    data = {}

    if (!url.length)
      numberOfFiles = $("#fileupload .template-download:not('.ui-state-error')").length
      minumumNumberOfFiles = parseInt($("#minimum_files").val())

      if (numberOfFiles < minumumNumberOfFiles)
        alert("You must upload at least #{minumumNumberOfFiles} file(s).")
        return
    else if ($.trim(url.val()) != '')
      data.url = url.val()
    else
      url.parent().addClass('has-error')
      url.focus()
      return
    submit(data)
  obj

$(document).ready ->
  Entries.init()