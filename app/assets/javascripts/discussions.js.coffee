# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  $('.edit_disc_desc').each ->
    $(this).editInPlace(
      url:"#{$(this).attr('id')}",
      field_type: "textarea",
      update_value: 'discussion[description]')
