
    var width = 960,
        height = 200;

    var color = d3.scale.category10();

    var nodes = [],
        links = [],
        relations = [];

    var node, link, relation;
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
                 .size([width, height])
                 .on("tick", tick);
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
                    .attr("class", function(d) { return "node " + d.id; });

                gNode.append("circle").attr("r", 14);

                gNode.append('text')
                      .attr("class", 'name')
                      .attr("text-anchor", "middle")
                      .attr("y", 40)
                      .text( function(d){ return d.name; });

                node.exit().remove();


    // link.order();
    // relation.order();
    node.order();

    force.start();
  }



  // Author
  function add_author(data){
    var node = {id: 1, name: data.name, circle: 0};
    pushNode(node);
    start();
  }



  function remove_author(){
    deleteNode(1)
    start();
  }


  // Father
  function add_father(data){
    var node = {id: 2, name: data.name, target: 1, relation: "отец", circle: 1};
    pushNode(node)
    start();
  }


  function remove_father(){
    deleteNode(2)
    start();
  }


  // Mother
  function add_mother(data){
    var node = {id: 3, name: data.name, target: 1, relation: "мать", circle: 1};
    pushNode(node)
    start();
  }


  function remove_mother(){
    deleteNode(3)
    start();
  }

  // Brothers
  var brothers_container = [];

  function add_brothers(data, index){
    var node_id = 40+index;
    brothers_container.push(node_id);
    var node = {id: node_id, name: data.name, target: 1, relation: "брат", circle: 1};
    pushNode(node)
    start();
  }


  function remove_brothers(index){
    deleteNode(brothers_container[index])
    brothers_container.splice(index, 1)
    start();
  }



  // Sisters
  var sisters_container = [];

  function add_sisters(data, index){
    var node_id = 50+index;
    sisters_container.push(node_id);
    var node = {id: node_id, name: data.name, target: 1, relation: "сестра"};
    pushNode(node)
    start();
  }


  function remove_sisters(index){
    deleteNode(sisters_container[index]);
    sisters_container.splice(index, 1)
    start();
  }



  // Sons
  var sons_container = [];

  function add_sons(data, index){
    var node_id = 60+index;
    sons_container.push(node_id);
    var node = {id: node_id, name: data.name, target: 1, relation: "сын"};
    pushNode(node)
    start();
  }

  function remove_sons(index){
    deleteNode(sons_container[index]);
    sons_container.splice(index, 1)
    start();
  }


  // Daughters
  var daughters_container = [];

  function add_daughters(data, index){
    var node_id = 70+index;
    daughters_container.push(node_id);
    var node = {id: node_id, name: data.name, target: 1, relation: "дочь"};
    pushNode(node)
    start();
  }


  function remove_daughters(index){
    deleteNode(daughters_container[index]);
    daughters_container.splice(index, 1)
    start();
  }



  // Wife
  function add_wife(data){
    var node = {id: 8, name: data.name, target: 1, relation: "жена"};
    pushNode(node)
    start();
  }


  function remove_wife(){
    deleteNode(8)
    start();
  }


  function add_husband(data){
    var node = {id: 9, name: data.name, target: 1, relation: "муж"};
    pushNode(node)
    start();
  }



  function remove_husband(){
    deleteNode(9)
    start();
  }




  // Data wirks
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


  var pushDataToGraph = function(modelName, model){
    eval('add_'+modelName+'(model)');
  }

  removeDataFormGraph = function(modelName){
    eval('remove_'+modelName+'()');
  }

  pushMultipleDataToGraph = function(modelName, model, index){
    eval('add_'+modelName+'(model, index)');
  }

  removeMultipleDataFormGraph = function(modelName, index){
    eval('remove_'+modelName+'('+index+')');
  }


  removeAllDataFormGraph = function(){
    remove_mother();
    remove_father();
    remove_wife();
    remove_husband();

    for (index = 0; index < brothers_container.length; ++index) {
      remove_brothers(index)
    }

    for (index = 0; index < sisters_container.length; ++index) {
      remove_sisters(index)
    }

    for (index = 0; index < sons_container.length; ++index) {
      remove_sons(index)
    }

    for (index = 0; index < daughters_container.length; ++index) {
      remove_daughters(index)
    }
  }




  // var init = function(){
    createForce();
    createSvg();
    resizeGraph();
  // }

  // init();
