var path_profile_ids = [];

var buildPath = function(data){

  var ul = document.getElementById('path_list');
  ul.innerHTML = ""; // clear current path
  path_profile_ids = []; // clear current path profile ids

  for (index = 0; index < data.length; ++index) {

    // console.log(data[index]);

    path_item = {}
    path_item.name          = data[index].name;
    path_item.id            = data[index].id;

    // next_index = index + 1;

    if (index == 0){
       path_item.is_relation = "Владелец дерева: ";
    }else{
      path_item.is_relation = data[index - 1].is_relation;
    }

    // path_item.is_relation   = data[index + 1].is_relation;

    // is_relation: "Жена"

    console.log(path_item);

    path_profile_ids.push(data[index].id);

    var li = buildPathLink(path_item);
    document.getElementById('path_list').appendChild(li);
  }


  // console.log("Path builders");
  // console.log(path_profile_ids);


}



var buildPathLink = function(profile){
  var li = document.createElement('li');
  var a = document.createElement('a');
  var linkText = document.createTextNode(profile.is_relation+' '+profile.name);
  a.appendChild(linkText);
  a.onclick = function(){
    getCircles({profile_id: profile.id});
  };
  a.href = "#";
  li.appendChild(a)
  return li;
}
