$ ->
  $('#login-window').hide()

  $('#new_updates_request')
  .bind 'ajax:success', (data, status, xhr) ->
    $('#new_updates_request').fadeOut 'fast', ->
      $('#form-box').append "<h1>Thanks! We'll be in touch soon.</h1>"

  $('.login-button').click ->
    $(@).toggleClass('flat round')
    $('#login-window').slideToggle(300)
