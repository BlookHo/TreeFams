var search_btn = $('#search-results-button');

getSearch = function(params){
  $.get( "/api/v1/search", { token: access_token } )
    .done(function( data ) {
      $(search_btn).text('Найдено ваших родственников: '+data.total);
    });
};
