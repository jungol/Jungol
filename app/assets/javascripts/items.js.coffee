$ ->
  $('ul.share-list li form').submit ->
    $(@).closest('li').hide()

  $('ul.share-list li form')
  .bind 'ajax:success', (data, status, xhr) ->
    $(@).closest('li').empty().append("<div class='share-success'>#{status.flash}</div>").show()

  $('input#select_all').click ->
    checkstatus = @.checked
    $(".group-check input:checkbox").each ->
      $(@).attr('checked', checkstatus)

  $('input#all_admins').click ->
    checkstatus = @.checked
    $(".admins-only input:checkbox").each ->
      $(@).attr('checked', checkstatus)
