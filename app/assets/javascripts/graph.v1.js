var dataset_empty = {
      nodes: []
};





var dataset = {
      nodes: [
          { id: 1, name: "Алексей",   role: "author",                  sex: 1,   rel: "это вы",        circle: 1,  image:'assets/man-2.png' },
          { id: 2, name: "Сергей",    role: "father",      target: 1,  sex: 1,   rel: "отец",          circle: 1,  image:'assets/man.png' },
          { id: 3, name: "Алла",      role: "mother",      target: 1,  sex: 0,   rel: "мама",          circle: 1,  image:'assets/w.png' },
          { id: 4, name: "Никита",    role: "brother",     target: 1,  sex: 1,   rel: "брат",          circle: 1,  image:'assets/m-3.png' },
          { id: 5, name: "Вероника",  role: "wife",        target: 1,  sex: 0,   rel: "жена",          circle: 1,  image:'assets/w.png' },
          { id: 6, name: "Макар",     role: "son",         target: 1,  sex: 1,   rel: "сын",           circle: 1,  image:'assets/man.png' },
          { id: 7, name: "Лука",      role: "son",         target: 1,  sex: 1,   rel: "сын",           circle: 1,  image:'assets/man.png' },
          { id: 8, name: "Никита",    role: "brother",     target: 5,  sex: 1,   rel: "брат",          circle: 2,  image:'assets/man.png' },
          { id: 9,  name: "Василий",   role: "father",     target: 3,  sex: 1,   rel: "отец",          circle: 2,  image:'assets/man.png' },
          { id: 24, name: "Ирина",      role: "mother",    target: 1,  sex: 0,   rel: "мама",          circle: 1,  image:'assets/man.png' },
          { id: 25, name: "Еще родня",  role: "more",      target:9,   sex: 0,    rel: "еще родня...", circle: 3,  image:'assets/man.png' }
      ]
};



var dataset_2 = {
      nodes: [
          { id: 10,  name: "Вероника", role: "author",                    sex: 0,  rel: "Это вы",  circle: 1, image:'assets/w.png' },
          { id: 11, name: "Николай",   role: "father",      target: 10,   sex: 1,  rel: "Отец",    circle: 1, image:'assets/man.png' },
          { id: 12, name: "Ирина",     role: "mother",      target: 10,   sex: 0,  rel: "Мама",    circle: 1, image:'assets/man.png' },
          { id: 13, name: "Никита",    role: "brother",     target: 10,   sex: 1,  rel: "Брат",    circle: 1, image:'assets/man.png' },
          { id: 14, name: "Алексей",   role: "husband",     target: 10,   sex: 1,  rel: "Муж",     circle: 1, image:'assets/man.png' },
          { id: 15, name: "Макар",     role: "son",         target: 10,   sex: 1,  rel: "Сын",     circle: 1, image:'assets/man.png' },
          { id: 16, name: "Лука",      role: "son",         target: 10,   sex: 1,  rel: "Сын",     circle: 1, image:'assets/man.png' }
      ]
};


var step = 1;

var width = 960,
    height = 500;


var nodes = [],
    links = [];


var pushNode,
    pushLink,
    findNode,
    findNodeIndex,
    updateNodeGraphic;


var linktext;


$(function(){

  // Resize
  function resize() {
    width = parseInt(d3.select("#graph").style("width"));
    height = parseInt(d3.select("#graph").style("height"));
  };

  d3.select(window).on('resize', resize);

  var color = d3.scale.category10();

  var force;


  var svg = d3.select("body").append("svg")
      .attr("width", width)
      .attr("height", height)
      .attr('id', 'graph');


  var node = svg.selectAll(".node"),
      link = svg.selectAll(".link");


  function click(node){
    if (node.role == "author"){
      showContextMenu(node.x, node.y);
    }else{
      // d3.select('#node_'+node.id)
      //   .classed('male', false);
      nodes = [];
      links = [];
      force = d3.layout.force()
                .nodes(nodes)
                .links(links);
      if (step == 1){
        dataset_2.nodes.forEach(function(d, i) {
          pushNode(d);
        });
        step = 2;
      }else{
        dataset.nodes.forEach(function(d, i) {
          pushNode(d);
        });
        step = 1;
      }
      reStart();
    }
  }




  function reStart() {

    force = d3.layout.force()
              .nodes(nodes)
              .links(links)
              .charge(-10000)
              .theta(0.1)
              .linkDistance(50)
              .linkStrength(1)
              .friction(0.7)
              .size([width, height])
              .on("tick", tick);

      link = link.data(force.links(), function(d) {
        return d.source.id + "-" + d.target.id;
      });

      link.enter().insert("line", ".node").attr("class", "link");

      // Link label
      linktext = svg.selectAll("g.linklabelholder").data(links);
      linktext.enter().append("g").attr("class", "linklabelholder")
       .append("text")
       .attr("dx", 1)
       .attr("dy", ".25em")
       .attr("class", "linklabel")
       .attr("text-anchor", "middle")
       .text(function(d) { return d.rel });


      link.exit().remove();

      // Nodes
      node = node.data(force.nodes(), function(d){
        return d.id;
      });


      node.enter()
          .append("g")
          .classed('node', true)
          .classed('male',   function(d){ return d.sex === 1})
          .classed('female', function(d){ return d.sex === 0})
          .classed('more',  function(d){ return d.circle === 3})
          .classed('author', function(d){
            return d.role === "author"
          })
          .attr('id', function(d){  return "node_"+d.id })
          .on('click', function(d){
            if (d3.event.defaultPrevented) return; // click suppressed
            click(d)
          })
          .call(force.drag);



      node.each(function(d,i){

        // Author node
        //////////////////////////////////////
        if (d.role == 'author'){

          // cirlce
          d3.select(this)
            .append("circle").attr('r', 60)

          // Crown image
          d3.select(this)
            .append("svg:image")
            .attr("xlink:href", "assets/crown.svg")
            .attr("width", 40)
            .attr("height", 40)
            .attr("x", -20)
            .attr("y",-95)
            .attr("class", "crown");

          // Avatar
          var defs = svg.append("defs").attr("id", "imgdefs")

          var clipPath = defs.append('clipPath').attr('id', 'clip-circle')
              .append("circle")
              .attr("r",  54)
              .attr("cy", 0)
              .attr("cx", 0);


          d3.select(this)
            .append("image")
            .attr("xlink:href", d.image)
            .attr("x", -54)
            .attr("y", -54)
            .attr("width", 110)
            .attr("height", 110)
            .attr("clip-path", "url(#clip-circle)");

          // Menu cirlce
          d3.select(this)
            .append("circle")
            .attr('cy', -40)
            .attr('cx', 40)
            .attr('class', 'button')
            .attr('r', 15);


          // Menu plus -
          d3.select(this)
            .append("rect")
            .attr("width", 16)
            .attr("height", 2)
            .attr("x", 32)
            .attr("y", -41)
            .attr("fill", "white");


        // Menu plus |
        d3.select(this)
          .append("rect")
          .attr("width", 2)
          .attr("height", 16)
          .attr("x", 39)
          .attr("y", -48)
          .attr("fill", "white");


        // name rect
        d3.select(this)
          .append("rect")
          .attr('x', -(140)/2)
          .attr('y', 25)
          .attr("width", 140)
          .attr("height", 25)
          .attr("class", 'rect');

        // name
        d3.select(this)
            .append("text")
            .attr("class", 'name')
            .attr("y", 42)
            .attr("text-anchor", "middle")
            .text(d.name);

        // relation rect
        d3.select(this)
          .append("rect")
          .attr('x', -(40)/2)
          .attr('y', 48)
          .attr("width", 40)
          .attr("height", 8)
          .attr("class", 'rect');


        // relation
        d3.select(this)
            .append("text")
            .attr("class", 'relation')
            .attr("y", 54)
            .attr("text-anchor", "middle")
            .text(d.rel);


        }else{

          // First level
          if (d.circle == 1){
            d3.select(this)
              .append("circle").attr('r', 40);

            var sdefs = svg.append("defs").attr("id", "imgdefs")

            var sclipPath = sdefs.append('clipPath').attr('id', 'sclip-circle')
                .append("circle")
                .attr("r",  36)
                .attr("cy", 0)
                .attr("cx", 0);


            d3.select(this)
              .append("image")
              .attr("xlink:href", d.image)
              .attr("x", -36)
              .attr("y", -36)
              .attr("width", 80)
              .attr("height", 80)
              .attr("clip-path", "url(#sclip-circle)")

            // name rect
            d3.select(this)
              .append("rect")
              .attr('x', -(76)/2)
              .attr('y', 21)
              .attr("width", 76)
              .attr("height", 15)
              .attr("class", 'rect');


          // name text
          d3.select(this)
              .append("text")
              .attr("class", 'name middle')
              .attr("y", 32)
              .attr("text-anchor", "middle")
              .text(d.name);
          };

          // Second level
          if (d.circle == '2'){
            d3.select(this)
              .append("circle").attr('r', 30);

            // name rect
            d3.select(this)
              .append("rect")
              .attr('x', -(70)/2)
              .attr('y', -4)
              .attr("width", 70)
              .attr("height", 16)
              .attr("class", 'rect');


            d3.select(this)
                .append("text")
                .attr("class", 'name middle')
                .attr("y", 8)
                .attr("text-anchor", "middle")
                .text(d.name);

          };


          // Threed level
          if (d.circle == '3'){
            d3.select(this)
              .append("circle").attr('r', 10);
          };

        }
      });
      node.exit().remove();
      force.start();
  };



  function tick() {

      // Nodes
      nodes[0].x = width / 2;
      nodes[0].y = height / 2 - 50;

      node.attr("transform", function(d) {
        return "translate(" + d.x + "," + d.y + ")";
      });


      // LInks
      link.attr("x1", function(d) { return d.source.x; })
          .attr("y1", function(d) { return d.source.y; })
          .attr("x2", function(d) { return d.target.x; })
          .attr("y2", function(d) { return d.target.y; });


      // Link labels
     linktext.attr("transform", function(d) {
      return "translate(" + (d.source.x + d.target.x) / 2 + ","
                          + (d.source.y + d.target.y) / 2 + ")"; });

  };




  findNode = function (id) {
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
    }



  pushNode = function(data){
    nodes.push(data);
    if (data.target){
      pushLink(data.id, data.target);
    }
  };


  pushLink = function(sourceId, targetId){
      var sourceNode = findNode(sourceId);
      var targetNode = findNode(targetId);
      if((sourceNode !== undefined) && (targetNode !== undefined)) {
          links.push({"source": sourceNode, "target": targetNode, "rel":sourceNode.rel});
      }
  };


  dataset.nodes.forEach(function(d, i) {
    pushNode(d);
  });


  resize()
  reStart();



});
