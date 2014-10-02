var dataset = [];

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

  link = svg.selectAll("line.link").data(links);

  link.enter()
      .append("svg:line")
      .attr("class", "link");
  link.exit().remove();


  // Link label
  linkLabel = svg.selectAll("g.linkLabel").data(links);
  linkLabel.enter().append("g")
           .attr("class", "linkLabel")
           .append("text")
           .attr("dx", 1)
           .attr("dy", ".25em")
           .attr("class", "linklabel")
           .attr("text-anchor", "middle")
           .text(function(d) {
             return d.rel;
            });



  node = svg.selectAll("g.node")
            .data(nodes);

  node.enter()
      .append("g")
      .attr("class", "node")
      .append("circle")
      .attr('r', function(d){
        return d.rel == 'author' ? 30 : 20;
      })
      .attr('fill', '#ccc')
      .call(force.drag);


  // var defs     = svg.append("defs").attr("id", "imgdefs");
  // var clipPath = defs.append('clipPath')
  //                    .attr('id', 'clip-circle')
  //                    .append("circle")
  //                    .attr("r", 50)
  //                    .attr("cy", 0)
  //                    .attr("cx", 0);



  node.append("image")
      .attr("xlink:href", function(d){ return d.image; })
      .attr("x", function(d){ return d.rel == 'author' ? -30 : -20;  })
      .attr("y", function(d){ return d.rel == 'author' ? -30 : -20;  })
      .attr("width", function(d){ return d.rel == 'author' ? 60 : 40;  })
      .attr("height", function(d){ return d.rel == 'author' ? 60 : 40;  });
      // .attr("clip-path", "url(#clip-circle)")


  node.exit().remove();



  force.on("tick", function() {
    if (nodes[0]){
      nodes[0].x = width / 2;
      nodes[0].y = 220;
    }

    link.attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });


    // Link labels
    linkLabel.attr("transform", function(d) {
            return "translate(" + (d.source.x + d.target.x) / 2 + ","
                                + (d.source.y + d.target.y) / 2 + ")";
     });

    node.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
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
        links.push({"source": sourceNode, "target": targetNode, "rel":sourceNode.rel, "id": sourceId});
    }
};


reloadDataset = function(){
  dataset.forEach(function(d) {
    pushNode(d);
  });
}


pushDataFromAngular = function(data){

  dataset = [];
  nodes = [];
  links = [];

  if ('author' in data){
    pushAuthorData( data.author );
  };

  if ('father' in data){
    pushFatherData( data.father );
  };

  if ('mother' in data){
    pushMotherData( data.father );
  };

  if ( ('brothers' in data) && (data.brothers.length > 0)){
    pushBrothersData( data.brothers);
  };

  if ( ('sisters' in data) && (data.sisters.length > 0)){
    pushSistersData( data.sisters);
  };

  if ( ('sons' in data) && (data.sons.length > 0)){
    pushSonsData( data.sons);
  };

  if ( ('daughters' in data) && (data.daughters.length > 0)){
    pushDaughtersData( data.daughters);
  };

  if ('wife' in data){
    pushWifeData( data.wife );
  };

  if ('husband' in data){
    pushHusbandData( data.husband );
  };

  reloadDataset();
  restartGraph();
};



pushAuthorData = function(data){
  if ( (data != undefined) && ( 'originalObject' in data ) ){
    var image = data.originalObject.sex_id == 1 ? '/assets/icon-man.png' : '/assets/icon-women.png'
    var node = {id: 1, name: data.title, rel: "author", relation: "это вы", sex: data.originalObject.sex_id, image: image};
    return dataset.push(node);
  }
}


pushFatherData = function(data){
  if ( (data != undefined)  && ( 'originalObject' in data ) ){
    var node = {id: 2, name: data.title, rel: "father", relation: "отец", sex: 1, target: 1, image: '/assets/icon-man.png'};
    return dataset.push(node);
  }
}


pushMotherData = function(data){
  if ( (data != undefined)  && ( 'originalObject' in data ) ){
    var node = {id: 3, name: data.title, rel: "mother", relation: "мать", sex: 0, target: 1, image: '/assets/icon-women.png'};
    return dataset.push(node);
  }
}



pushBrothersData = function(data){
  for (var i=0; i < data.length; i++) {
    if ( 'originalObject' in data[i] ){
      var node_id = '4-'+i;
      var node = {id: node_id, name: data.title, rel: "brother", relation: "брат", sex: 1, target: 1, image: '/assets/icon-man.png'};
      dataset.push(node);
    }
  };
  return dataset;
}


pushSistersData = function(data){
  for (var i=0; i < data.length; i++) {
    if ( 'originalObject' in data[i] ){
      var node_id = '5-'+i;
      var node = {id: node_id, name: data.title, rel: "sister", relation: "сестра", sex: 0, target: 1, image: '/assets/icon-women.png'};
      dataset.push(node);
    }
  };
  return dataset;
}


pushSonsData = function(data){
  for (var i=0; i < data.length; i++) {
    if ( 'originalObject' in data[i] ){
      var node_id = '6-'+i;
      var node = {id: node_id, name: data.title, rel: "son", relation: "сын", sex: 1, target: 1, image: '/assets/icon-man.png'};
      dataset.push(node);
    }
  };
  return dataset;
}


pushDaughtersData = function(data){
  for (var i=0; i < data.length; i++) {
    if ( 'originalObject' in data[i] ){
      var node_id = '7-'+i;
      var node = {id: node_id, name: data.title, rel: "daughters", relation: "дочь", sex: 0, target: 1, image: '/assets/icon-women.png'};
      dataset.push(node);
    }
  };
  return dataset;
}


pushWifeData = function(data){
  if ( (data != undefined)  && ( 'originalObject' in data ) ){
    var node = {id: 8, name: data.title, rel: "wife", relation: "жена", sex: 0, target: 1, image: '/assets/icon-women.png'};
    return dataset.push(node);
  }
}


pushHusbandData = function(data){
  if ( (data != undefined)  && ( 'originalObject' in data ) ){
    var node = {id: 9, name: data.title, rel: "husband", relation: "муж", sex: 1, target: 1, image: '/assets/icon-man.png'};
    return dataset.push(node);
  }
}



$(function(){
  createGraph();
  initGraph();
  resizeGraph();
});
