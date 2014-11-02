Judging = do($ = jQuery) ->
  obj = {}
  viewCaptions = false
  hash = null
  nextHash = null
  prevHash = null

  _setPrevAndNextLinks = ->
    prevHash = $("#entry-#{hash}").attr("data-previous-entry")
    nextHash = $("#entry-#{hash}").attr("data-next-entry")

    if (!nextHash)
      nextHash = $(".sidebar-entry-hash").first().attr("data-entry-hash")

  _setPlace = (placeId) ->
    $.ajax "/judging/entry/#{hash}/place",
      type: 'put'
      data: { id: placeId }
      success: (data) ->
        console.log(data)
        if (data.next)
          window.location.href = $("#entry-#{hash}").attr("data-next-entry")
        else
          window.location.reload()
      error: (data) ->
        alert(data.responseJSON.message)

  obj.init = ->
    params = location.pathname.split("/")
    hash = params[params.length - 1]

    $("#judging-category").on("change", ->
      categoryId = $(this).val()
      window.location.href = "/judging/entries/#{categoryId}"
    )

    $(".place-button").click( ->
      _setPlace($(this).attr("data-place-id"))
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
      if ($("#blueimp-gallery").is(":visible"))
        if (e.altKey && e.keyCode == 67)
          currentCaption = $("#current-caption")
          if (currentCaption.is(":visible"))
            currentCaption.hide()
            viewCaptions = false
          else
            currentCaption.show()
            viewCaptions = true
      else
        if (e.keyCode == 37)
          window.location.href = prevHash
        else if (e.keyCode == 39)
          window.location.href = nextHash
    , false)

    _setPrevAndNextLinks()
    $("#previous-entry").click( -> $("#previous-entry").attr("href", prevHash))
    $("#next-entry").click( -> $("#next-entry").attr("href", nextHash))
  obj

$(document).ready ->
  Judging.init()