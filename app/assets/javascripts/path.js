var buildPath = function(data){

  // tmp fix
  return;

  var ul = document.getElementById('path_list');
  ul.innerHTML = "";

  for (index = 0; index < data.length; ++index) {
    var profile = data[index];
    var li = buildPathLink(profile);
    document.getElementById('path_list').appendChild(li);
  }

}



var buildPathLink = function(profile){
  var li = document.createElement('li');
  var a = document.createElement('a');
  var linkText = document.createTextNode(profile.name);
  a.appendChild(linkText);
  a.onclick = function(){
    getCircles({profile_id: profile.id, path_from_profile_id: current_user_profile_id});
  };
  a.href = "#";
  li.appendChild(a)
  return li;
}
