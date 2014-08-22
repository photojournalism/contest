@initLoadingButton = (selector) ->
  button = $(selector)
  button.empty().append('<i class="glyphicon glyphicon-refresh spin"></i>')
  button.attr('disabled', 'disabled')

@endLoadingButton = (selector, text) ->
  button = $(selector)
  button.empty().append(text)
  button.removeAttr('disabled')

@fadeInMessage = (selector, message) ->
  $(selector).hide();
  $("#{selector}-message").empty().append(message);
  $(selector).fadeIn(300); 