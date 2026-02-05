# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
refreshAccordions = ->
  $('.accordion-item').each ->
    $item = $(this)
    $collapseEl = $item.find('.accordion-collapse')
    $header = $item.find('.accordion-header')

    if $collapseEl.length > 0
      # Find checked boxes
      hasChecked = $collapseEl.find('input[type="checkbox"]:checked').length > 0

      # Get Bootstrap instance
      instance = bootstrap.Collapse.getOrCreateInstance($collapseEl[0], { toggle: false })

      if hasChecked
        instance.show()
        $header.addClass 'has-checked'
      else
        instance.hide()
        $header.removeClass 'has-checked'

# 2. Run on initial page load
$ ->
  refreshAccordions()

# 3. Run after clicking Submit
# Replace '.submit-btn' with your actual button class or ID
$(document).on 'click', '.submit-btn', ->
  # Use a slight delay to allow the form/checkbox states to process
  setTimeout (-> refreshAccordions()), 50

$(document).on 'click', '.custom-clickable-row', (e) ->
  url = $(this).data('href')
  window.open(url, '_blank')
  return

$(document).ready ->

  $('#clearAllCheckboxesBtn').click ->
    $('input[type=\'checkbox\']').attr 'checked', false
    return

  $('#searchWord').on 'input', ->
    hasText = $(this).val().length > 0
    $('input[type="checkbox"]').prop 'disabled', hasText
    $('input[type="checkbox"]').prop('checked', false);
    return

  $('input[type="checkbox"]').on 'click', ->
    $('#searchWord').val ''
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
