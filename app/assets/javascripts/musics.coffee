# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $(document).on 'turbolinks:load', ->
    #te turbolinks dziwnie działa
    # działa za pierwszym wejściu, ale później nie działą (po odświeżeniu)
    $('#audio-player').mediaelementplayer
      alwaysShowControls: true
      features: [
        'playpause'
        'volume'
        'progress'
      ]
      audioVolume: 'horizontal'
      audioWidth: 400
      audioHeight: 120
    return


# $(document).ready ->
#   $("button[title='Play']").click ->
#     console.log "Działa klik"
#     # $.ajax
#     #   url: '/increment.json'
#     #   data: 'music_id': '<%= @music.id %>'
#     #   async: false
