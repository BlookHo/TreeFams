var width = 960,
    height = 200;

var color = d3.scale.category10();

var nodes = [],
    links = [],
    relations = [];

var node, link, relation;
var force, svg;

var current_circle_author;
var current_center_profile_id;

createSvg = function(){
  svg = d3.select("#graph-wrapper")
           .append("svg")
           .attr("width",  width)
           .attr("height", height)
           .attr('id', 'graph');

};


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
};


var drag;




start = function(){


  force = d3.layout.force()
               .nodes(nodes)
               .links(links)
               .charge(-600)
               // .theta(0.1)
               // .linkDistance(0)
               .linkDistance(function(e){
                 var distance =  Math.round(100 / e.distance);
                 return distance;
               })
               // .linkStrength(1)
               // .friction(0.7)
               .size([width, height])
               .on("tick", tick);


  drag = force.drag()
              .on("dragstart", dragstart);


  // Links
  link = svg.selectAll(".link").data(links, function(d) { return d.source.id + "-" + d.target.id; });
         link.enter()
             .insert("line")
             .classed("link", true)
             .classed("blue", function(d){
               return ~path_profile_ids.indexOf(d.id);
             });

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
                  .attr("class", function(d) { return "node " + 'distance_' + d.distance; })
                  .on("dblclick", dblclick)
                  .call(drag);


  // Zoom
  ///////////////////////////////////////
  // gNode.select(function(d){
  //   d3.select(this)
  //     .attr("transform","scale(2)")
  // })
  // node.on("mouseover",function(){ d3.select(this).transition().attr("transform","scale(1.2)") });


  // Center node
  //////////////////////////////////////
  gNode.select(function(d){
    if (d.distance === 0){


        // Add center class to center node group
        d3.select(this)
          .classed('center', true)
          .transition()
          .attr("transform","scale(2)");



        // Name label
        d3.select(this)
              .append('text')
              .attr("class", 'name')
              .attr("text-anchor", "middle")
              .attr("y", 55)
              //.text( function(d){ return d.display_name + ' ' + d.id; });
              .text( function(d){ return d.name + ' ' + d.id; });



          // Profile SVG Icon
          d3.select(this)
            .append("image")
            .attr("xlink:href", function(d){ return d.avatar; })
            .attr("width", 80)
            .attr("height", 80)
            .attr("x", -40)
            .attr("y", -40)
            .attr("class", "icon");



          // Profile Rounded Avatar EXTREMALY SLOW!!!

          // http://stackoverflow.com/questions/7430580/setting-rounded-corners-for-svgimage
          // http://stackoverflow.com/questions/25524906/how-to-make-an-image-round-in-d3-js

          // d3.select(this)
          //   .append('defs')
          //
          //   .append("pattern")
          //   .attr("id", "center_pattern")
          //   .attr("height", 100)
          //   .attr("width", 100)
          //
          //   .append("image")
          //   .attr("height", 100)
          //   .attr("width", 100)
          //   .attr("x", 0)
          //   .attr("y", 0)
          //   .attr("xlink:href", function(d){ return d.avatar; });
          //
          //
          // d3.select(this)
          //   .append("circle")
          //   .attr("r", 80)
          //   .attr("fill", "url(#center_pattern)");






        // Plus icon (dropdown menu)
        if (d.has_rights){
           d3.select(this)
             .append("svg:image")
             .attr("xlink:href", "/assets/plus.svg")
             .attr("width", 24)
             .attr("height", 24)
             .attr("x", 18)
             .attr("y", -40)
             .attr("class", "add-icon");
         }


         // Registrated user's icon
         if (d.user_id){
            d3.select(this)
              .append("svg:image")
              .attr("xlink:href", "/assets/registrated.svg")
              .attr("width", 16)
              .attr("height", 16)
              .attr("x", -32)
              .attr("y", 22)
              .attr("class", "registrated-icon");
         }



         // Search green mark
         if ( ~search_marked_profile_ids.indexOf(d.id) ) {
           d3.select(this)
             .append("svg:image")
             .attr("xlink:href", "/assets/mark.svg")
             .attr("width", 16)
             .attr("height", 16)
             .attr("x", -32)
             .attr("y", -32)
             .attr("class", "add-icon");
         }


        // Click event
        d3.select(this)
          .on('click', function(d){
            if (d3.event.defaultPrevented) return; // click suppressed
            // showProfileMenu({profile_id: d.id});
            showProfileContextMenu({profile_id: d.id});
          });

      }
  });



    // First circle nodes
    //////////////////////////////////////
    gNode.select(function(d){
      if (d.distance == 1){

        // Name label
        d3.select(this)
              .append('text')
              .attr("class", 'name')
              .attr("text-anchor", "middle")
              .attr("y", 35)
              //.text( function(d){ return d.display_name + ' ' + d.id; });
              .text( function(d){ return d.name + ' ' + d.id; });


        // Profile icon
        d3.select(this)
          .append("svg:image")
          .attr("xlink:href", function(d){ return d.avatar; })
          .attr("width", 50)
          .attr("height", 50)
          .attr("x", -25)
          .attr("y", -25)
          .attr("class", "icon");


        // Search green mark
        if ( ~search_marked_profile_ids.indexOf(d.id) ) {
          d3.select(this)
            .append("svg:image")
            .attr("xlink:href", "/assets/mark.svg")
            .attr("width", 24)
            .attr("height", 24)
            .attr("x", 8)
            .attr("y", -40)
            .attr("class", "add-icon");
        }



        // Registrated user's icon
        if (d.user_id){
           d3.select(this)
             .append("svg:image")
             .attr("xlink:href", "/assets/registrated.svg")
             .attr("width", 16)
             .attr("height", 16)
             .attr("x", -24)
             .attr("y", 7)
             .attr("class", "registrated-icon");
        }



        // Click event
        d3.select(this)
          .on('click', function(d){
            if (d3.event.defaultPrevented) return; // click suppressed
              // getCircles({profile_id: d.id, path_from_profile_id: current_user_profile_id});
              getCircles({ profile_id: d.id });
          });


      }
    });



    // Second circle nodes
    //////////////////////////////////////
    gNode.select(function(d){
      if (d.distance == 2){

        // Name label
        d3.select(this)
              .append('text')
              .attr("class", 'name')
              .attr("text-anchor", "middle")
              .attr("y", 35)
              .text( function(d){ return d.name + ' (id:'+ d.id+')'; });
              //.text( function(d){ return d.display_name; });


        // Profile's icon
        d3.select(this)
          .append("svg:image")
          .attr("xlink:href", function(d){ return d.avatar; })
          .attr("width", 30)
          .attr("height", 30)
          .attr("x", -15)
          .attr("y", -15)
          .attr("class", "icon");


        // Search green mark
        if ( ~search_marked_profile_ids.indexOf(d.id) ) {
          d3.select(this)
            .append("svg:image")
            .attr("xlink:href", "/assets/mark.svg")
            .attr("width", 18)
            .attr("height", 18)
            .attr("x", 4)
            .attr("y", -20)
            .attr("class", "add-icon");
        }


        // Registrated user's icon
        if (d.user_id){
           d3.select(this)
             .append("svg:image")
             .attr("xlink:href", "/assets/registrated.svg")
             .attr("width", 16)
             .attr("height", 16)
             .attr("x", -18)
             .attr("y", 0)
             .attr("class", "registrated-icon");
        }

        // Click event
        d3.select(this)
          .on('click', function(d){
            if (d3.event.defaultPrevented) return; // click suppressed
            // getCircles({profile_id: d.id, path_from_profile_id: current_user_profile_id});
            getCircles({ profile_id: d.id });
          });

      }
    });




    // Small dots circle nodes
    //////////////////////////////////////
    gNode.select(function(d){
      if (d.distance > 2){

        // Name label
        d3.select(this)
              .append('text')
              .attr("class", 'name')
              .attr("text-anchor", "middle")
              .attr("y", 15)
              // .text( function(d){ return d.name + ' (id:'+ d.id+')'; });
              .text( function(d){ return d.name; });


        // Grey circle
        d3.select(this)
          .append("circle")
          .attr('r', 7)
          .attr('fill', '#ccc')


        // Search green mark
        if ( ~search_marked_profile_ids.indexOf(d.id) ) {
          d3.select(this)
            .append("svg:image")
            .attr("xlink:href", "/assets/mark.svg")
            .attr("width", 18)
            .attr("height", 18)
            .attr("x", 4)
            .attr("y", -20)
            .attr("class", "add-icon");
        }

          // Registrated user's icon
          if (d.user_id){
              d3.select(this)
                  .append("svg:image")
                  .attr("xlink:href", "/assets/registrated.svg")
                  .attr("width", 12)
                  .attr("height", 12)
                  .attr("x", -12)
                  .attr("y", 2)
                  .attr("class", "registrated-icon");
          }

        // Click event
        d3.select(this)
          .on('click', function(d){
            if (d3.event.defaultPrevented) return; // click suppressed
            // getCircles({profile_id: d.id, path_from_profile_id: current_user_profile_id});
            getCircles({ profile_id: d.id });
          });

      }
    });






  node.exit().remove();
  node.order();
  force.start();
}

function dblclick(d) {
  d3.select(this).classed("fixed", d.fixed = false);
}


function dragstart(d) {
  d3.select(this).classed("fixed", d.fixed = true);
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
        links.push({id: sourceId, source: sourceNode, target: targetNode, distance: sourceNode.distance });
        relations.push({id: sourceId, source: sourceNode, target: targetNode, relation: sourceNode.relation, distance: sourceNode.distance});
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



// getCircles({ profile_id: current_user_profile_id, token: access_token });
getCircles = function(params){
  clearNodes();
  var max_distance = getCurrentDistance();
  current_center_profile_id = params.profile_id;
  $.get( "/api/v1/circles", { profile_id: params.profile_id, token: access_token, path_from_profile_id: params.path_from_profile_id, max_distance: max_distance } )
    .done(function( data ) {
          console.log("Graph: data recieved at:"+ Date.now());
        buildPath(data.path);
        current_circle_author = data.cirlce_author;
        // jsdebug(data);
        data.circles.forEach(function(d, i) {
          pushNode(d);
        });
        start();
          console.log("Graph: after start"+ Date.now());
    });
};



showProfileContextMenu = function(params){
  $.get( "/profile/context-menu", params);
}



$(window).on('resize', function (e) {
  resizeGraph();
  start();
});


function contains(a, obj) {
    for (var i = 0; i < a.length; i++) {
        if (a[i] === obj) {
            return true;
        }
    }
    return false;
}



createSvg();
resizeGraph();
