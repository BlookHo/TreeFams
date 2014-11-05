$(function(){
  hideContextMenu();

  $(document).on('click', function(e){
      console.log( $('circle.author').has(e.target).length );
      if ( $('#context-menu').has(e.target).length == 0 ) {
        if ( $('g.author').has(e.target).length === 0 ){
          console.log('called');
          hideContextMenu();
        };
      };
  });
});



function hideContextMenu(){
  $('#context-menu').hide();
}



function showContextMenu(x,y){
  $('#context-menu').show();
  $('#context-menu').css('left', Math.round(x)+59+"px" );
  $('#context-menu').css('top', Math.round(y)-58+"px" );
}
