$(function(){

  var currentZoom;

  $('#zoom-range').change(function () {
    var zoomValue = $(this).val();
    console.log(zoomValue);
    getCircles({ profile_id: current_user_profile_id, token: access_token, max_distance: 1 });
  });

});
