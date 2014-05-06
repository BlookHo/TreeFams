jQuery ->
  $('#name_select').autocomplete
    source: $('#name_select').data('names')
