$ ->
  $('#new_updates_request')
  .bind 'ajax:success', (data, status, xhr) ->
    $('#new_updates_request').append "Thanks!"
