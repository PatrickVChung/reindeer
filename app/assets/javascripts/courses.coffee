# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '.custom-clickable-row', (e) ->
  url = $(this).data('href')
  window.open(url, '_blank')
  return
$(document).ready ->
  $('#searchWord').on 'input', ->
    hasText = $(this).val().length > 0
    $('input[type="checkbox"]').prop 'disabled', hasText
    $('input[type="checkbox"]').prop('checked', false);
    return

  $('input[type="checkbox"]').on 'click', ->
    $('#searchWord').val ''
    return
