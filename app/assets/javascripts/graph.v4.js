
var svg,
    force,
    node, link;

var width  = 980,
    height = 200;

var nodes = [],
    links = [],
    color = d3.scale.category10();

// var circles,
//     connectors;


createGraph = function(){
  svg = d3.select("#graph-wrapper")
          .append("svg")
          .attr("width",  width)
          .attr("height", height)
          .attr('id', 'graph');
};


initGraph = function(){
  force = d3.layout.force()
            .charge(-1000)
            .theta(0.1)
            .linkDistance(50)
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


  // link = svg.selectAll("line.link")
  //           .data(force.links(), function(d) { return d.source.id + "-" + d.target.id; });

  link = svg.selectAll("line.link").data(links);
  link.enter()
      .append("svg:line")
      .attr("class", "link");
  link.exit().remove();



  node = svg.selectAll("g.node")
            .data(force.nodes(), function(d) { return d.id;});

  node.enter()
      .append("g")
      .attr("class", "node")
      .append("circle")
      .attr('r', 20)
      .attr('fill', "grey")
      .call(force.drag);


  node.exit().remove();




  force.on("tick", function() {
    if (nodes[0]){
      nodes[0].x = width / 2;
      nodes[0].y = height / 2 - 180;
    }

    link.attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

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


findNodesByType = function(type) {
    var results = [];
    for (var i=0; i < nodes.length; i++) {
        if (nodes[i].type === type)
            results.push(nodes[i]);
    };
    return results;
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
}




pushLink = function(sourceId, targetId){
    var sourceNode = findNode(sourceId);
    var targetNode = findNode(targetId);
    if((sourceNode !== undefined) && (targetNode !== undefined)) {
        links.push({"source": sourceNode, "target": targetNode, "rel":sourceNode.rel, "id": sourceId});
    }
};



// compareNodes = function(obj1, obj2){
//   console.log(JSON.stringify(obj1));
//   console.log(JSON.stringify(obj2));
//   return JSON.stringify(obj1) === JSON.stringify( obj2 );
// }


pushDataFromAngular = function(data){
  if ('author' in data){
    pushAuthorNode( data );
  };
  if ('father' in data){
    pushFatherNode( data );
  };
  if ('mother' in data){
    pushMotherNode( data );
  };
  if ('brothers' in data){
    pushBrothersData( data );
  };
  restartGraph();
};


pushAuthorNode = function(data){
  if ( ( data.author != undefined) && ( 'originalObject' in data.author ) ) {
    var node = {id: 1, name: data.title, rel: "author", rel_title: "это вы", sex: data.sex_id};
    deleteNode(1);
    pushNode(node);
  }else{
    nodes = [];
  }
};


pushFatherNode = function(data){
  if ( ( data.father != undefined) && ( 'originalObject' in data.father ) ) {
    var node = {id: 2, name: data.title, rel: "father",  rel_title: "отец", sex: 1, target: 1};
    deleteNode(2);
    pushNode(node);
  }else{
    deleteNode(2);
  }
};


pushMotherNode = function(data){
  if ( ( data.mother != undefined) && ( 'originalObject' in data.mother ) ) {
    var node = {id: 3, name: data.title, rel: "mother", rel_title: "мать", sex: 0, target: 1};
    deleteNode(3);
    pushNode(node);
  }else{
    deleteNode(3);
  }
};


pushBrothersData = function(data){
  if ( ( data.brothers != undefined) && ( data.brothers.length > 0 ) ) {
    for (var i=0; i < data.brothers.length; i++) {
      if ( 'originalObject' in data.brothers[i] ){
        pushBrotherNode(data.brothers[i], i);
      }
    };
  };
};


pushBrotherNode = function(data, index){
  // console.log('push brother node');
  // console.log(data);
  if ( 'originalObject' in data ){
    var node_id = '4-'+index;
    var node = {id: node_id, name: data.title, rel: "brother", rel_title: "брат", sex: 1, target: 1};
    deleteNode(node_id);
    pushNode(node);
  }else{
    deleteNode('4-'+index);
  }
}



$(function(){
  createGraph();
  initGraph();
  resizeGraph();
});
