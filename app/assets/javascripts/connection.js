$(function(){

  $('a.connect').on('click', function(e){
    e.preventDefault();
    var url = $(this).attr('href');
    $('a.connect').addClass('disabled');

    setTimeout(function(){
      window.location.href = url;
    }, 50);

  });

})
