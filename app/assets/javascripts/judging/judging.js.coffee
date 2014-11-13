@Judging = do($ = jQuery) ->
  obj = {}
  viewCaptions = true
  viewButtons = true
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

  _setPlaceAjax = (placeId, entry_hash, index) ->
    $.ajax "/judging/entry/#{entry_hash}/place",
      type: 'put'
      data: { id: placeId }
      success: (data) ->
        $("#single-image-#{index}").attr("data-place", placeId)
        $(".single-image-place-button").removeAttr("disabled")
        $("#place-#{placeId}").attr("disabled", "disabled")
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
      _setPlace($(this).attr("data-place-number"))
    )

    $('#blueimp-gallery').on('opened', (event) ->
      if (viewCaptions)
        $("#current-caption").show()
      $("#single-image-buttons").fadeIn(200)
    ).on('closed', (event) ->
      $("#current-caption").hide()
      $("#single-image-buttons").hide()
    ).on('slide', (event, index, slide) ->
      $("#current-caption").empty().append($.trim($("#caption-#{index}").html()))
      $(".single-image-place-button").attr("data-index", index)
      $(".single-image-place-button").removeAttr("disabled")
      place = $("#single-image-#{index}").attr("data-place")
      $("#place-#{place}").attr("disabled", "disabled")
      console.log(place)
    )

    $("#sidebar-entries").height($("#entry-view").height() + 100)

    slider = $("#slider")
    slider.slider({
      min: 200,
      max: 500,
      step: 25,
      value: 300,
      formatter: (value) ->
        "#{value}px"
    })

    slider.on('slideStop', ->
      width = slider.slider('getValue')
      height = width * (2.0/3.0)
      $(".judging-entry-image").css('width', "#{width}px")
      $(".judging-entry-image").css('height', "#{height}px")
      setTimeout( ->
        $("#sidebar-entries").height($("#entry-view").height() + 100)
      , 300)
    )

    document.addEventListener('keyup', (e) ->
      if ($("#blueimp-gallery").is(":visible"))
        if (e.keyCode == 67)
          currentCaption = $("#current-caption")
          if (currentCaption.is(":visible"))
            currentCaption.hide()
            viewCaptions = false
          else
            currentCaption.show()
            viewCaptions = true
        if (e.keyCode == 66)
          buttons = $("#single-image-buttons")
          if (buttons.is(":visible"))
            buttons.fadeOut(200)
            viewButtons = false
          else
            buttons.fadeIn(200)
            viewButtons = true

      else
        if (e.keyCode == 37)
          window.location.href = prevHash
        else if (e.keyCode == 39)
          window.location.href = nextHash
        else if (e.keyCode >= 49 && e.keyCode <= 52)
          _setPlace(e.keyCode - 48)
        else if (e.keyCode == 48)
          _setPlace(5)
    , false)

    $(".single-image-place-button").click( ->
      index = $(this).attr("data-index")
      entry_hash = $("#single-image-#{index}").attr("data-entry")
      _setPlaceAjax($(this).attr("data-place-number"), entry_hash, index)
    )

    _setPrevAndNextLinks()
    $("#previous-entry").click( -> $("#previous-entry").attr("href", prevHash))
    $("#next-entry").click( -> $("#next-entry").attr("href", nextHash))
  obj