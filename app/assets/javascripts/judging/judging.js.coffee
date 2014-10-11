Judging = do($ = jQuery) ->
  obj = {}

  obj.init = ->
    $("#judging-category").on("change", ->
      categoryId = $(this).val()
      window.location.href = "/judging/entries/#{categoryId}"
    )

  obj

$(document).ready ->
  Judging.init()