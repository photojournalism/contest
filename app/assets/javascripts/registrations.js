var Registrations = (function($) {
  var obj = {};

  obj.getStates = function(countryId) {
    if (!countryId) {
      countryId = $("#user_country_id").val();
    }
    
    $.get("/states/select/" + countryId, function(data) {
      $("#user_state_id").html(data);
    });
  };

  obj.init = function() {
    $("#user_country_id").val(233);

    obj.getStates();
    $("#user_country_id").on('change', function() {
      obj.getStates($(this).val());
    });
  };

  return obj;
}(jQuery));