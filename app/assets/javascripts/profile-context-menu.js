// Close profile context menu on outside click
$(function(){

  // $('.ui-autocomplete').has(e.target).length === 0 )

  $(document).on('click', function(e){
    if ( $('#profile-context-menu').has(e.target).length == 0 ) {
      if ( ($('g.center').has(e.target).length === 0) &&  ( $('.ui-autocomplete').has(e.target).length === 0)  )  {
        $('#profile-context-menu').hide();
      }
    }
  });


});
