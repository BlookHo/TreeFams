var getCurrentDistance = function(){

  var distance;
  var zoom =  $('#zoom-range').val();

  if (zoom == 1){
    console.log('Zoome graph!');
    $('#graph-wrapper').addClass('zoomed');
    distance = 1;
  }else if (zoom == 2){
    $('#graph-wrapper').removeClass('zoomed');
    distance = 2;
  }else if (zoom == 3){
    $('#graph-wrapper').removeClass('zoomed');
    distance = 5;
  }else{
    $('#graph-wrapper').removeClass('zoomed');
    distance = 10
  }
  return distance;
}



$(function(){
  $('#zoom-range').change(function () {
    var distance = getCurrentDistance();
    getCircles({ profile_id: current_center_profile_id, token: access_token, max_distance: distance });
  });

});
