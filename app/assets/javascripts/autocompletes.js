initNameAutocomplete = function(field_id, sex_id){

  $(field_id).on("keydown.autocomplete", function(){

    $(this).autocomplete({
      source: "/autocomplete/names?sex_id="+sex_id,
      select: function(event,ui){
        $(field_id).val(ui.item.name);
        $("#new_profile_name_id").val(ui.item.id);
        return false;
      },
      focus: function(event, ui) {
            $(field_id).val(ui.item.name);
            $("#new_profile_name_id").val(ui.item.id);
            return false;
        },
    }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
      return $( "<li>" )
      .append( "<a>" + item.name + "</a>" )
      .appendTo( ul );
    };

  });

}
