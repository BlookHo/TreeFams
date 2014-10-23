var width = 960,
    height = 200;

var color = d3.scale.category10();

var nodes = [],
    links = [],
    relations = [];

var node, link, relation;
var force, svg;


// createForce = function(){
//   force = d3.layout.force()
//                .nodes(nodes)
//                .links(links)
//                .charge(-15000)
//                .theta(0.1)
//                .linkDistance(-200)
//                .linkStrength(1)
//                .friction(0.7)
//                .size([width, height])
//                .on("tick", tick);
// }


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
  // force.size([width, height]).resume();
};



tick = function(){

  if (nodes[0]){
    nodes[0].x = width / 2;
    nodes[0].y = (height / 2)-100;
  }

  node = svg.selectAll(".node");
  node.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });


  relation = svg.selectAll(".relation");
  relation.attr("transform", function(d) {
          return "translate(" + (d.source.x + d.target.x) / 2 + ","
                              + (d.source.y + d.target.y) / 2 + ")";
   });


  link = svg.selectAll(".link");
  link.attr("x1", function(d) { return d.source.x; })
      .attr("y1", function(d) { return d.source.y; })
      .attr("x2", function(d) { return d.target.x; })
      .attr("y2", function(d) { return d.target.y; });
}




start = function(){

  force = d3.layout.force()
               .nodes(nodes)
               .links(links)
               .charge(-7500)
               .theta(0.1)
               .linkDistance(0)
               .linkStrength(1)
               .friction(0.7)
               .size([width, height])
               .on("tick", tick);

  // Links
  link = svg.selectAll(".link").data(links, function(d) { return d.source.id + "-" + d.target.id; });
  link.enter().insert("line").attr("class", "link");
  link.exit().remove();


  // Relations
  relation = svg.selectAll('.relation').data(relations, function(d) { return d.source.id + "-" + d.target.id; });
             relation.enter()
                     .append("g")
                     .attr("class", "relation")
                     .append("text")
                     .attr("class", "label")
                     .attr("dx", 1)
                     .attr("dy", ".25em")
                     .attr("text-anchor", "middle")
                     .text(function(d) { return d.relation; });

  relation.exit().remove();



  // Nodes
  node = svg.selectAll(".node").data(nodes, function(d) { return d.id });

  var gNode = node.enter()
                  .append("g")
                  .attr("class", function(d) { return "node " + d.id; })
                  .classed('current', function(d){ return d.current_user_profile; })
                  .on('click', function(d){
                    if (d3.event.defaultPrevented) return; // click suppressed
                    getCircles({profile_id: d.id});
                  })
                  .call(force.drag);


              // Node circle
              // gNode.append("circle")
              //       .attr("r", function(d){
              //         if (d.circle == 0){
              //           return 30;
              //         }else if(d.circle == 1){
              //           return 20;
              //         }else{
              //           return 7;
              //         }
              //       });


              gNode.append("svg:image")
                   .attr("xlink:href", function(d){ return d.icon; })
                   .attr("width", 40)
                   .attr("height", 40)
                   .attr("x", -20)
                   .attr("y", -20)
                   .attr("transform", function(d){
                     if (d.circle == 0) { return "scale(1.6)"}
                     else if (d.circle == 1) { return "scale(1.3)"}
                     else if (d.circle == 2) { return "scale(1)"}
                   })
                   .attr("class", "icon");

              gNode.append('text')
                    .attr("class", 'name')
                    .attr("text-anchor", "middle")
                    .attr("y", 40)
                    .text( function(d){ return d.name; });

              node.exit().remove();

  node.order();

  force.start();
}




// Data works
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
      relations.splice(index, 1);
    }
};


pushLink = function(sourceId, targetId){
    var sourceNode = findNode(sourceId);
    var targetNode = findNode(targetId);
    if((sourceNode !== undefined) && (targetNode !== undefined)) {
        links.push({id: sourceId, source: sourceNode, target: targetNode, });
        relations.push({id: sourceId, source: sourceNode, target: targetNode, relation: sourceNode.relation});
    }
};



clearNodes = function(){
  if (node != undefined){
    d3.selectAll("svg > *").remove();
     nodes = [];
     links = [];
     relations = [];
     force.start();
     d3.timer(force.resume);
  }
}




getCircles = function(params){
  clearNodes();
  $.get( "/api/v1/circles", { profile_id: params.profile_id, token: access_token } )
    .done(function( data ) {
        data.forEach(function(d, i) {
          pushNode(d);
        });
        start();
    });
}



$(window).on('resize', function (e) {
  resizeGraph();
  start();
});



createSvg();
resizeGraph();
