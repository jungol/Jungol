## Place all the behaviors and hooks related to the matching controller here.
## All this logic will automatically be available in application.js.
$ ->
  $('.edit_doc_desc').each ->
    $(this).editInPlace(
      url:"#{$(this).attr('id')}",
      field_type: "textarea",
      update_value: 'document[description]')
