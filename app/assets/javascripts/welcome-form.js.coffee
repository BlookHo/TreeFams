jQuery ->
  $('#name').autocomplete
    source: $('#name').data('names')
