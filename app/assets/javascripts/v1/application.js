//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require v1/welcome-form.js
//= require v1/dropdown.js
//= require v1/overlay.js
//= require v1/new_profile_questions.js
//= require v1/path-results.js


$(function(){
  $('form#welcome_form').on('submit', function() {
    $('#next').attr('disabled', true);
  });
})
