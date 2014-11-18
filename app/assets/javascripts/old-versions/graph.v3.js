var test_node = {
  id: 1,
  name: "Алексей",
  role: "author",
  sex: 1,
  rel: "это вы",
  circle: 1,
  image:'assets/man-2.png'
};


var width  = 960,
    height = 300;

var nodes = [],
    links = [];
    color = d3.scale.category10();

var svg,
    force;
// var node, link;


var circles,
    connectors;


createGraph = function(){
  svg = d3.select("#graph-wrapper").append("svg")
          .attr("width",  width)
          .attr("height", height)
          .attr('id', 'graph');
};


initGraph = function(){
  force = d3.layout.force()
            .nodes(nodes)
            .links(links)
            .charge(-10000)
            .theta(0.1)
            .linkDistance(50)
            .linkStrength(1)
            .friction(0.7)
            .size([width, height])
            .on("tick", graphTick);

  circles = svg.selectAll('g');
  connectors = svg.selectAll('line');
};


// Resize graph
resizeGraph = function() {
  width = parseInt(d3.select("#graph-wrapper").style("width"));
  height = parseInt(d3.select("#graph-wrapper").style("height"));
};


restartGraph = function() {
  // Nodes
  circles = circles.data(nodes);

  var g = circles.enter()
          .append("g")
          .classed('node', true)
          .call(force.drag);

         g.append("circle")
          .attr('r', 20)
          .attr('fill', "grey");

  circles.exit().remove();


  // Links
  connectors = connectors.data(force.links(), function(d) {
    return d.source.id + "-" + d.target.id;
  });
  connectors.enter().insert("line", ".node").attr("class", "link");
  connectors.exit().remove();


  force.start();
};



graphTick = function() {
    // Nodes
    circles.attr("transform", function(d) {
      return "translate(" + d.x + "," + d.y + ")";
    });

    // Links
    connectors.attr("x1", function(d) { return d.source.x; })
              .attr("y1", function(d) { return d.source.y; })
              .attr("x2", function(d) { return d.target.x; })
              .attr("y2", function(d) { return d.target.y; });

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
}





pushLink = function(sourceId, targetId){
    var sourceNode = findNode(sourceId);
    var targetNode = findNode(targetId);
    if((sourceNode !== undefined) && (targetNode !== undefined)) {
        links.push({"source": sourceNode, "target": targetNode, "rel":sourceNode.rel, "id": sourceId});
    }
};



compareNodes = function(obj1, obj2){
  console.log(JSON.stringify(obj1));
  console.log(JSON.stringify(obj2));
  return JSON.stringify(obj1) === JSON.stringify( obj2 );
}



pushDataFromAngular = function(data){
  if ( ('author' in data) && ( data.author != undefined) && ( 'originalObject' in data.author ) ) {
      pushAuthorNode( data.author.originalObject );
  }
  if ( ('father' in data) && ( data.father != undefined) && ( 'originalObject' in data.father ) ) {
      pushFatherNode( data.father.originalObject );
  }
  if ( ('mother' in data) && ( data.mother != undefined) && ( 'originalObject' in data.mother ) ) {
      pushMotherNode( data.mother.originalObject );
  }
  restartGraph();
};


pushAuthorNode = function(data){
  var node = {id: 1, name: data.title, rel: "author", rel_title: "это вы", sex: data.sex_id};
  deleteNode(1);
  pushNode(node);
};


pushFatherNode = function(data){
  var node = {id: 2, name: data.title, rel: "father",  rel_title: "отец", sex: 1, target: 1};
  deleteNode(2);
  pushNode(node);
};


pushMotherNode = function(data){
  var node = {id: 3, name: data.title, rel: "mother", rel_title: "мать", sex: 0, target: 1};
  deleteNode(3);
  pushNode(node);
};



$(function(){
  // resize
  resizeGraph();
  // create svg for Graph
  createGraph();
  // init Force Layout
  initGraph();

  // $(window).on('resize', function (e) {
  //   restartGraph();
  // });

});
