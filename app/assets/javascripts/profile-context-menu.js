// Close profile context menu on outside click
$(function(){

  $(document).on('click', function(e){
    if ( $('#center-profile-menu').has(e.target).length == 0 ) {
      if ( $('g.center').has(e.target).length === 0 ){
        $('#center-profile-menu').hide();
      }
    }
  });

});
