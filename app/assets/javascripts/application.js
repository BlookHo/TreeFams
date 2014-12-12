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
//= require libs/ngRemoteValidate.0.6.1.min.js
//= require apps/welcome_application



function jsdebug(objekt){
  $('#jsdebug').text( JSON.stringify(objekt) );
}
