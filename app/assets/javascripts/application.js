//  Base
//----------------------------------
//= require jquery
//= require jquery_ujs
//= require jquery.ui.autocomplete
//= require jquery.ui.draggable
//= require profile-context-menu.js
//= require autocompletes.js

//  D3js.org
//----------------------------------
//= require libs/d3


//  Angular (templates: app/assets/templates)
//----------------------------------
//= require libs/angular
//= require libs/angular-ui-router
//= require angular-rails-templates
//= require libs/ui-bootstrap-tpls-0.9.0
//= require_tree ./templates
//= require apps/welcome_application


// Papercrop
//= require jquery.jcrop
//= require papercrop

// Notifications
//= require libs/jquery.noty.packaged.min.js
//= require notifications.js

//= require connection


//= require admin/bootstrap.min.js
//= require admin/bootstrap-select.js


function jsdebug(objekt){
  $('#jsdebug').text( JSON.stringify(objekt) );
};
