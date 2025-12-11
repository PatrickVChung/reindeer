$(document).ready ->
  $('#courseDataTable2').DataTable 'ordering': true, "pageLength": 100
  $('.dataTables_length').addClass 'bs-select'
