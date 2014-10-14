
var width = 960,
    height = 200;

var color = d3.scale.category10();

var nodes = [],
    links = [];

var node, link, nameLabel, relationLabel;
var force, svg;


createForce = function(){
  force = d3.layout.force()
               .nodes(nodes)
               .links(links)
               .charge(-15000)
               .theta(0.1)
               .linkDistance(20)
               .linkStrength(1)
               .friction(0.7)
               .size([width, height]);
               // .on("tick", tick);
}


createSvg = function(){
  svg = d3.select("#graph-wrapper")
           .append("svg")
           .attr("width",  width)
           .attr("height", height)
           .attr('id', 'graph');
}



resizeGraph = function(){
  width = parseInt(d3.select("#graph-wrapper").style("width"));
  height = parseInt(d3.select("#graph-wrapper").style("height"));

  svg.attr("width", width).attr("height", height);
  force.size([width, height]).resume();
};



tick = function(){
  if (nodes[0]){
      nodes[0].x = width / 2;
      nodes[0].y = 220;
  }
  node.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });


  link.attr("x1", function(d) { return d.source.x; })
      .attr("y1", function(d) { return d.source.y; })
      .attr("x2", function(d) { return d.target.x; })
      .attr("y2", function(d) { return d.target.y; });


  nameLabel.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
}




start = function(){


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
            .attr("y", 40)
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


  // Link between node
  // link = svg.selectAll("line.link").data(force.links());
  // link.enter()
  //     .insert("svg:line")
  //     .attr("class", "link");
  // link.exit().remove();
  //
  //
  //
  // node = svg.selectAll("g.node").data(nodes);
  // node.enter()
  //     .append("g")
  //     .attr("class", "node")
  //     .append("circle")
  //     .attr('r', function(d){
  //       return d.rel == 'author' ? 30 : 20;
  //     })
  //     .attr('fill', '#ccc')
  //     .call(force.drag);
  // node.exit().remove();
  //
  //
  // nameLabel = svg.selectAll("g.nameLabel").data(nodes);
  // nameLabel.enter()
  //           .append("g")
  //           .attr('class', 'nameLabel')
  //           .append('text')
  //           .attr("class", 'name')
  //           .attr("text-anchor", "middle")
  //           .attr("y", 50)
  //           .text( function(d){ return d.name; });
  // nameLabel.exit().remove();




  // link = link.data(force.links(), function(d) { return d.source.id + "-" + d.target.id; });
  // link.enter().insert("line", ".node").attr("class", "link");
  // link.exit().remove();

  // node = node.data(force.nodes(), function(d) { return d.id;});
  // node.enter()
  //     .append("circle")
  //     .attr("class", function(d) { return "node " + d.id; })
  //     .attr("r", 8);
  // node.exit().remove();





  // name = svg.selectAll("g.nameLable").data(nodes);
  // name.enter()
  //           .append("g")
  //           .attr('class', 'nameLable')
  //           .append('text')
  //           .attr("class", 'name')
  //           .attr("text-anchor", "middle")
  //           .attr("y", 20)
  //           .text( function(d){ return d.name; });
  // name.exit().remove();


  // force.start();
}



pushNode = function(data){
    nodes.push(data);
    if (data.target){
      pushLink(data.id, data.target);
    }
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
    console.log("delet node index:"+index);
    if (index != undefined){
        nodes.splice(index, 1);
        deleteLink(id);
    }
}


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
        links.push({source: sourceNode, target: targetNode, id: sourceId, rel_title:sourceNode.rel_title});
    }
};



function add_author(data){
  var node = {id: 1, name: data.name};
  pushNode(node);
  start();
}


function add_father(data){
  var node = {id: 2, name: data.name, target: 1, rel_title: "отец"};
  pushNode(node)
  start();
}


function add_mother(data){
  var node = {id: 3, name: data.name, target: 1, rel_title: "мать"};
  pushNode(node)
  start();
}


function add_brothers(data, index){
  var node_id = 41+index;
  var node = {id: node_id, name: data.name, target: 1, rel_title: "брат"};
  pushNode(node)
  start();
}


function remove_brothers(index){
  var node_id = 41+index;
  deleteNode(node_id)
  start();
}


function add_sisters(data, index){
  var node_id = '5-'+index+'';
  var node = {id: node_id, name: data.name, target: 1, rel_title: "сестра"};
  pushNode(node)
  start();
}


function add_sons(data, index){
  var node_id = '6-'+index+'';
  var node = {id: node_id, name: data.name, target: 1, rel_title: "сын"};
  pushNode(node)
  start();
}


function add_daughters(data, index){
  var node_id = '7-'+index+'';
  var node = {id: node_id, name: data.name, target: 1, rel_title: "дочь"};
  pushNode(node)
  start();
}


function add_wife(data){
  var node = {id: 8, name: data.name, target: 1, rel_title: "жена"};
  pushNode(node)
  start();
}


function add_husband(data){
  var node = {id: 9, name: data.name, target: 1, rel_title: "муж"};
  pushNode(node)
  start();
}



function remove_author(){
  deleteNode(1)
  start();
}


function remove_father(){
  deleteNode(2)
  start();
}


function remove_mother(){
  deleteNode(3)
  start();
}




function remove_sisters(index){
  var node_id = '5-'+index;
  deleteNode(node_id)
  start();
}


function remove_sons(index){
  var node_id = '6-'+index;
  deleteNode(node_id)
  start();
}


function remove_daughters(index){
  var node_id = '7-'+index;
  deleteNode(node_id)
  start();
}


pushDataToGraph = function(modelName, model){
  eval('add_'+modelName+'(model)');
}


pushMultipleDataToGraph = function(modelName, model, index){
  eval('add_'+modelName+'(model, index)');
}


removeDataFormGraph = function(modelName){
  eval('remove_'+modelName+'()');
}


removeMultipleDataFormGraph = function(modelName, index){
  eval('remove_'+modelName+'('+index+')');
}




$(function(){

  createForce();
  createSvg();
  resizeGraph();

  node = svg.selectAll(".node"),
  link = svg.selectAll(".link");




  // 1. Add three nodes and three links.
  // setTimeout(function() {
  //   var a = {id: "a"}, b = {id: "b"}, c = {id: "c"};
  //   nodes.push(a, b, c);
  //   links.push({source: a, target: b}, {source: a, target: c}, {source: b, target: c});
  //   start();
  // }, 0);
  //
  //
  // // 2. Remove node B and associated links.
  // setTimeout(function() {
  //   nodes.splice(1, 1); // remove b
  //   links.shift(); // remove a-b
  //   links.pop(); // remove b-c
  //   start();
  // }, 3000);
  //
  //
  // // Add node B back.
  // setTimeout(function() {
  //   var a = nodes[0], b = {id: "b"}, c = nodes[1];
  //   nodes.push(b);
  //   links.push({source: a, target: b}, {source: b, target: c});
  //   start();
  // }, 6000);



});
