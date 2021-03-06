var dataset =  [];

var svg,
    force,
    node, link;

var width  = 980,
    height = 200;

var nodes = [],
    links = [],
    color = d3.scale.category10();


createGraph = function(){
  svg = d3.select("#graph-wrapper")
          .append("svg")
          .attr("width",  width)
          .attr("height", height)
          .attr('id', 'graph');
};


initGraph = function(){
  force = d3.layout.force()
            .charge(-15000)
            .theta(0.1)
            .linkDistance(30)
            .linkStrength(1)
            .friction(0.7)
            .size([width, height]);
};



function resizeGraph() {
  width = parseInt(d3.select("#graph-wrapper").style("width"));
  height = parseInt(d3.select("#graph-wrapper").style("height"));

  svg.attr("width", width).attr("height", height);
  force.size([width, height]).resume();
};


restartGraph = function(){
  force
      .nodes(nodes)
      .links(links);


  // Link between node
  link = svg.selectAll("line.link").data(links);
  link.enter()
      .append("svg:line")
      .attr("class", "link");
  link.exit().remove();


  // Relation label on link
  relationLabel = svg.selectAll("g.relationLabel").data(links);
  relationLabel.enter()
           .append("g")
           .attr("class", "relationLabel")
           .append("text")
           .attr("class", "relation")
           .attr("dx", 1)
           .attr("dy", ".25em")
           .attr("text-anchor", "middle")
           .text(function(d) { return d.rel_title; });
  relationLabel.exit().remove();



  node = svg.selectAll("g.node").data(nodes);
  node.enter()
      .append("g")
      .attr("class", "node")
      .append("circle")
      .attr('r', function(d){
        return d.rel == 'author' ? 30 : 20;
      })
      .attr('fill', '#ccc')
      .call(force.drag);
  node.exit().remove();


  nameLabel = svg.selectAll("g.nameLabel").data(nodes);
  nameLabel.enter()
            .append("g")
            .attr('class', 'nameLabel')
            .append('text')
            .attr("class", 'name')
            .attr("text-anchor", "middle")
            .attr("y", 50)
            .text( function(d){ return d.name; });
  nameLabel.exit().remove();




  force.on("tick", function() {

    if (nodes[0]){
      nodes[0].x = width / 2;
      nodes[0].y = 220;
    }
    node.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });


    link.attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });


    // relationLabel
    relationLabel.attr("transform", function(d) {
            return "translate(" + (d.source.x + d.target.x) / 2 + ","
                                + (d.source.y + d.target.y) / 2 + ")";
     });


     // relationLabel
     nameLabel.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });



  });


  force.start();

};






findNode = function(id) {
    for (var i=0; i < nodes.length; i++) {
        if (nodes[i].id === id)
            return nodes[i]
    };
};


findNodeIndex = function (id) {
    for (var i=0; i < nodes.length; i++) {
        if (nodes[i].id === id)
            return i
    };
};


deleteNode = function(id){
    var index = findNodeIndex(id);
    if (index != undefined){
      nodes.splice(index, 1);
      deleteLink(id);
    }
}


pushNode = function(data){
    nodes.push(data);
    if (data.target){
      pushLink(data.id, data.target);
    }
};



findLink = function(id) {
    for (var i=0; i < links.length; i++) {
        if (links[i].id === id)
            return links[i]
    };
};


findLinkIndex = function (id) {
    for (var i=0; i < links.length; i++) {
        if (links[i].id === id)
            return i
    };
};



deleteLink = function(id){
    var index = findLinkIndex(id);
    if (index != undefined){
      links.splice(index, 1);
    }
};



pushLink = function(sourceId, targetId){
    var sourceNode = findNode(sourceId);
    var targetNode = findNode(targetId);
    if((sourceNode !== undefined) && (targetNode !== undefined)) {
        links.push({"source": sourceNode, "target": targetNode, "rel":sourceNode.rel, "rel_title": sourceNode.rel_title, "id": sourceId});
    }
};


reloadDataset = function(){
  dataset.forEach(function(d) {
    pushNode(d);
  });
}



pushDataToGraph = function(data){

  dataset = [];
  nodes = [];
  links = [];


  try{
    if ( data.author.hasOwnProperty('name') ){
      pushAuthorData( data.author );
    }
  }catch(e){}


  try{
    if ( data.father.hasOwnProperty('name') ){
      pushFatherData( data.father );
    }
  }catch(e){}

  try{
    if ( data.mother.hasOwnProperty('name') ){
      pushMotherData( data.mother );
    }
  }catch(e){}

  try{
    if ( data.brothers.length > 0 ){
      pushBrothersData( data.brothers );
    }
  }catch(e){}

  try{
    if ( data.sisters.length > 0 ){
      pushSistersData( data.sisters );
    }
  }catch(e){}

  try{
    if ( data.sons.length > 0 ){
      pushSonsData( data.sons );
    }
  }catch(e){}

  try{
    if ( data.daughters.length > 0 ){
      pushSonsData( data.daughters );
    }
  }catch(e){}

  try{
    if ( data.wife.hasOwnProperty('name') ){
      pushWifeData( data.wife );
    }
  }catch(e){}

  try{
    if ( data.husband.hasOwnProperty('name') ){
      pushHusbandData( data.husband );
    }
  }catch(e){}



  // try{
  //   if ( data.author.hasOwnProperty('name') ){
  //     pushAuthorData( data.author );
  //   }
  //
  //
  //   if ( data.father.hasOwnProperty('name') ){
  //     pushFatherData( data.father );
  //   }
  //
  //   if ( data.mother.hasOwnProperty('name') ){
  //     pushMotherData( data.mother );
  //   }
  //
  //   if ( data.brothers.length > 0 ){
  //     pushBrothersData( data.brothers );
  //   }
  //
  //   if ( data.sisters.length > 0 ){
  //     pushSistersData( data.sisters );
  //   }
  //
  //   if ( data.sons.length > 0 ){
  //     pushSonsData( data.sons );
  //   }
  //
  //   if ( data.daughters.length > 0 ){
  //     pushSonsData( data.daughters );
  //   }
  //
  //   if ( data.wife.hasOwnProperty('name') ){
  //     pushWifeData( data.wife );
  //   }
  //
  //   if ( data.husband.hasOwnProperty('name') ){
  //     pushHusbandData( data.husband );
  //   }
  //
  // }catch(e){
  //   console.log('Incomplete object');
  // };


  reloadDataset();
  restartGraph();
};



// pushAuthorData = function(data){
//   if ( (data != undefined) && ( 'name' in data ) ){
//     var image = data.sex_id == 1 ? '/assets/icon-man.png' : '/assets/icon-women.png'
//     var node = {id: 1, name: data.name, rel: "author", rel_title: "это вы", sex: data.sex_id, image: image};
//     return dataset.push(node);
//   }
// }


pushAuthorData = function(data){
  var image = data.sex_id == 1 ? '/assets/icon-man.png' : '/assets/icon-women.png'
  var node = {id: 1, name: data.name, rel: "author", rel_title: "это вы", sex: data.sex_id, image: image};
  return dataset.push(node);
}



pushFatherData = function(data){
  var node = {id: 2, name: data.name, rel: "father", rel_title: "отец", sex: 1, target: 1, image: '/assets/icon-man.png'};
  return dataset.push(node);
}


pushMotherData = function(data){
  var node = {id: 3, name: data.name, rel: "mother", rel_title: "мать", sex: 0, target: 1, image: '/assets/icon-women.png'};
  return dataset.push(node);
}



pushBrothersData = function(data){
  for (var i=0; i < data.length; i++) {
    if ( 'name' in data[i] ){
      var node_id = '4-'+i;
      var node = {id: node_id, name: data[i].name, rel: "brother", rel_title: "брат", sex: 1, target: 1, image: '/assets/icon-man.png'};
      dataset.push(node);
    }
  };
  return dataset;
}


pushSistersData = function(data){
  for (var i=0; i < data.length; i++) {
    if ( 'name' in data[i] ){
      var node_id = '5-'+i;
      var node = {id: node_id, name: data[i].name, rel: "sister", rel_title: "сестра", sex: 0, target: 1, image: '/assets/icon-women.png'};
      dataset.push(node);
    }
  };
  return dataset;
}



pushSonsData = function(data){
  for (var i=0; i < data.length; i++) {
    if ( 'name' in data[i] ){
      var node_id = '6-'+i;
      var node = {id: node_id, name: data[i].name, rel: "son", rel_title: "сын", sex: 1, target: 1, image: '/assets/icon-man.png'};
      dataset.push(node);
    }
  };
  return dataset;
}


pushDaughtersData = function(data){
  for (var i=0; i < data.length; i++) {
    if ( 'name' in data[i] ){
      var node_id = '7-'+i;
      var node = {id: node_id, name: data[i].name, rel: "daughters", rel_title: "дочь", sex: 0, target: 1, image: '/assets/icon-women.png'};
      dataset.push(node);
    }
  };
  return dataset;
}


pushWifeData = function(data){
  var node = {id: 8, name: data.name, rel: "wife", rel_title: "жена", sex: 0, target: 1, image: '/assets/icon-women.png'};
  return dataset.push(node);
}


pushHusbandData = function(data){
  var node = {id: 9, name: data.name, rel: "husband", rel_title: "муж", sex: 1, target: 1, image: '/assets/icon-man.png'};
  return dataset.push(node);
}



$(function(){
  createGraph();
  initGraph();
  resizeGraph();
});
