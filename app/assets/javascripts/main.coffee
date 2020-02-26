# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.flash_listener = ->
  $(".flash-format .flash-delete").click (e)->
    e.preventDefault()
    $(this).closest(".flash-format").addClass('flash-hidden')

$(document).on('turbolinks:load', window.flash_listener)
