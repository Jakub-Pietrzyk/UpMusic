# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

updateScroll = ->
  element = document.getElementById("chat-content");
  element.scrollTop = element.scrollHeight
  return


$(document).ready ->
  updateScroll();
  #nie działa przy pierwszym wejściu na strone
  return
