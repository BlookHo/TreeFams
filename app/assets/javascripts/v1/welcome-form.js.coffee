jQuery ->
  $(document).on "keydown.autocomplete", ".autocomplete_field", (e) ->
    $(".autocomplete_field").each ->
      $(this).autocomplete
        source: (request, response) ->
          names = $('.autocomplete_field').first().data('names')
          matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( request.term ), "i" );
          response( $.grep( names, (item) ->
                  return matcher.test( item )
          ))
        select: ( event, ui ) ->
          # $("#welcome-form input:text, #formId textarea").blur()

  $("#welcome-form input:text, #formId textarea").first().focus();
