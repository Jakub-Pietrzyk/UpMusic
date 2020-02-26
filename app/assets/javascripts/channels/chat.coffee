App.chat = App.cable.subscriptions.create "ChatChannel",
  connected: ->
    console.log("connected")

  disconnected: ->
    console.log('disconnected')

   received: (data) ->
    span = $(data['message'])
    $('#chat-content')[0].append(span[0])
    element = document.getElementById("chat-content");
    element.scrollTop = element.scrollHeight

  speak: (message, chatroom, user) ->
    @perform 'speak', message: message, chatroom: chatroom, user: user

$(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
  if event.keyCode is 13 # return/enter = send
    App.chat.speak(event.target.value, $("input#chatroom-id")[0].value, $("input#message-user")[0].value)
    event.target.value = ''
    event.preventDefault()
