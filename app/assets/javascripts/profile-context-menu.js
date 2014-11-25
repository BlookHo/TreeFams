// Close profile context menu on outside click
$(function(){

  $(document).on('click', function(e){
    if ( $('#profile-context-menu').has(e.target).length == 0 ) {
      if ( $('g.center').has(e.target).length === 0 ){
        $('#profile-context-menu').hide();
      }
    }
  });


});
