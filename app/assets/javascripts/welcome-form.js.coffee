initAutocompleteFields = ()->
  $('.autocomplete_field').autocomplete
    source: (request, response) ->
      names = $('.autocomplete_field').first().data('names')
      matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( request.term ), "i" );
      response( $.grep( names, (item) ->
              return matcher.test( item )
      ))




cloneFormControlField = () ->
  $('#welcome_form .control').first().clone().insertAfter( "#welcome_form h2" )
  $('#welcome_form input[type="text"]').first().val('')
  initAutocomplete()



jQuery ->
  initAutocompleteFields()

  $('#clone').on 'click', ->
    cloneFormControlField()
