Judging = do($ = jQuery) ->
  obj = {}
  viewCaptions = false
  hash = null

  _updatePrevAndNextLinks = ->
    prevHash = $("#entry-#{hash}").attr("data-previous-entry")
    nextHash = $("#entry-#{hash}").attr("data-next-entry")

    if (!nextHash)
      nextHash = $(".sidebar-entry-hash").first().attr("data-entry-hash")

    $("#previous-entry").attr("href", prevHash)
    $("#next-entry").attr("href", nextHash)

  obj.init = ->
    params = location.pathname.split("/")
    hash = params[params.length - 1]

    $("#judging-category").on("change", ->
      categoryId = $(this).val()
      window.location.href = "/judging/entries/#{categoryId}"
    )

    $('#blueimp-gallery').on('opened', (event) ->
      if (viewCaptions)
        $("#current-caption").show()
    ).on('closed', (event) ->
      $("#current-caption").hide()
    ).on('slide', (event, index, slide) ->
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

    _updatePrevAndNextLinks()
  obj

$(document).ready ->
  Judging.init()