Registrations = do($ = jQuery) ->
  obj = {}

  obj.getStates = (countryId) ->
    if !countryId
      countryId = $("#user_country_id").val()

    $.get "/states/select/" + countryId, (data) ->
      $("#user_state_id").html(data)

  obj.init = ->
    $("#user_country_id").change ->
      obj.getStates($(this).val())

  obj

$(document).ready ->
  Registrations.init()