Contact = do($ = jQuery) ->

  obj = {}

  obj.init = ->
    $("#problem-submit").click ->
      obj.reportAProblem()

  obj.reportAProblem = ->
    description = $("#problem-description")

    if ($.trim(description.val()) != '')
      initLoadingButton("#problem-submit")
      $.ajax "/contact/report_a_problem",
        type: 'post'
        data: { message: description.val() }
        success: (data) ->
          alert(data.message)
          $("#contactModal").modal('hide')
          description.val('')
        error: (data) ->
          alert(data.responseJSON.message)
          description.focus()
      .done ->
        endLoadingButton("#problem-submit", 'Send')
    else
      description.parent().addClass('has-error')
      description.focus()

  obj

$(document).ready ->
  Contact.init()