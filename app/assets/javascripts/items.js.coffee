$ ->
  $('ul.share-list li form')
  .bind 'ajax:success', (data, status, xhr) ->
    $(@).closest('li').empty().append("<div class='share-success'>#{status.flash}</div>")
