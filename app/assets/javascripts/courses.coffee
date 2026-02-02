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

  $('#clearAllCheckboxesBtn').click ->
    $('input[type=\'checkbox\']').attr 'checked', false
    return

  $('.accordion').on 'change', 'input[type="checkbox"]', ->
    $checkbox = $(this)
    $item = $checkbox.closest('.accordion-item')
    $panel = $item.find('.accordion-collapse')
    $header = $item.find('.accordion-header')
    hasChecked = $panel.find('input[type="checkbox"]:checked').length > 0
    # Debug (optional)
    console.log 'Changed in item:', $item.attr('id') or '(no id)', 'hasChecked:', hasChecked
    collapse = bootstrap.Collapse.getOrCreateInstance($panel[0])
    if hasChecked
      collapse.show()
      $header.addClass 'has-checked'
    else
      $header.removeClass 'has-checked'
      # Optional: auto-close when no checks
      # collapse.hide();
    return
  $('.accordion-collapse').on 'hide.bs.collapse', (e) ->
    if $(this).find('input[type="checkbox"]:checked').length > 0
      e.preventDefault()
    return
  return
