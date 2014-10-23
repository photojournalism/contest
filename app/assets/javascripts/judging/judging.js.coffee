Judging = do($ = jQuery) ->
  obj = {}

  obj.init = ->
    $("#judging-category").on("change", ->
      categoryId = $(this).val()
      window.location.href = "/judging/entries/#{categoryId}"
    )

    $(".judging-entry-image-link").click( ->
      number = $(this).attr("data-index")
      $("#current-caption").empty().append($.trim($("#caption-#{number}").html()))
    )
    $('#blueimp-gallery').on('opened', (event) ->
      $("#current-caption").show()
    ).on('closed', (event) ->
      $("#current-caption").hide()
    ).on('slidecomplete', (event, index, slide) ->
      $("#current-caption").empty().append($.trim($("#caption-#{index}").html()))
    )

    $("#current-caption").click( ->
      $(this).hide()
    )

  obj

$(document).ready ->
  Judging.init()