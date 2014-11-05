var path_profile_ids = [];

var buildPath = function(data){

  // if (data.length == undefined){ return; }
  // return;

  var ul = document.getElementById('path_list');
  ul.innerHTML = ""; // clear current path
  path_profile_ids = []; // clear current path profile ids

  for (index = 0; index < data.length; ++index) {

    path_profile_ids.push(data[index].id);

    var profile = data[index];
    var li = buildPathLink(profile);
    document.getElementById('path_list').appendChild(li);
  }


  console.log("Path builders");
  console.log(path_profile_ids);


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
