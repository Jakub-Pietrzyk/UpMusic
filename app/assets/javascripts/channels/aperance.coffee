App.cable.subscriptions.create "AperanceChannel",

  connected: ->
    @perform("appear");

  disconnected: ->
    @perform("disappear");


  received: (data) ->
    if data["online"] == true
      $(userImgIdConstructor(data)).attr 'class', 'active';
    else
      $(userImgIdConstructor(data)).attr 'class', 'inactive';

  userImgIdConstructor = (user) ->
    return "#" + user["id"];
