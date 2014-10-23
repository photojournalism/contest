Judging = do($ = jQuery) ->
  obj = {}
  viewCaptions = false

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
      if (viewCaptions)
        $("#current-caption").show()
    ).on('closed', (event) ->
      $("#current-caption").hide()
    ).on('slidecomplete', (event, index, slide) ->
      $("#current-caption").empty().append($.trim($("#caption-#{index}").html()))
    )

    document.addEventListener('keyup', (e) ->
      if (e.altKey && e.keyCode == 67 && $("#blueimp-gallery").is(":visible"))
        currentCaption = $("#current-caption")
        if (currentCaption.is(":visible"))
          currentCaption.hide()
          viewCaptions = false
        else
          currentCaption.show()
          viewCaptions = true
    , false)

  obj

$(document).ready ->
  Judging.init()