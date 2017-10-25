Users = do($ = jQuery) ->
  
  obj = {}

  obj.init = ->
    $("#add-user-button").click -> obj.addUser()
      
  
  obj.addUser = ->
    initLoadingButton("#add-user-button")
    $.ajax({
      url: '/users/add',
      type: 'post',
      data: {
        'first_name': $("#first-name").val(),
        'last_name': $("#last-name").val()
      },
      success: (data) ->
        console.log(data)
        $usersList = $("#users-list");
        html = $usersList.html();
        $usersList.html(html + "<li>" + data.first_name + " " + data.last_name + "</li>")
        endLoadingButton("#add-user-button", 'Add')
        $("#no-users").hide()
      error: (data) ->
        alert("An error occurred, please try again");
        console.log(data.responseJSON.message)
        endLoadingButton("#add-user-button", 'Add')
    });

  return obj

$(document).ready ->
  Users.init()