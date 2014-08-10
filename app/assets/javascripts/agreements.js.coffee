Agreements = do($ = jQuery) ->
  obj = {}

  obj.validate = (e) ->
    checked = $("#contest-agreement-checkbox").prop("checked")

    if !checked
      e.preventDefault()
      alert('You must agree to the contest rules to enter the contest.')
      return false
    return true
  
  obj

$(document).ready ->
  $("#contest-agreement-form").submit (e) ->
    return Agreements.validate(e)