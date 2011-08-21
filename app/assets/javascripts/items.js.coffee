$ ->
  $('ul.share-list li form')
  .bind 'ajax:success', (data, status, xhr) ->
    $(@).closest('li').empty().append("<div class='share-success'>#{status.flash}</div>")

  $('input#select_all').click ->
    checkstatus = @.checked
    $(".group-check input:checkbox").each ->
      $(@).attr('checked', checkstatus)

  $('input#all_admins').click ->
    checkstatus = @.checked
    $(".admins-only input:checkbox").each ->
      $(@).attr('checked', checkstatus)
