# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('ul.group-groups li form')
  .bind 'ajax:success', (data, status, xhr) ->
    $(@).closest('div.group-status').empty().append("<span class='status'>#{status.flash}</div>")
