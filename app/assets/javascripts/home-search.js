var search_btn = $('#search-results-button');
var search_results;
var search_marked_profile_ids = [];


getSearchResults = function(params){
  $.get( "/api/v1/search", { token: access_token } )
    .done(function( data ) {
      search_results = data.trees;
      $(search_btn).text('Найдено ваших родственников: '+data.total);
      // $('#jsdebug').text(JSON.stringify(search_results))
    });
};



showSearchResult = function(){
  $.get( "/api/v1/search", { token: access_token } )
    .done(function( data ) {
      console.log('Search results');
      console.log(data);
      search_results = data.circles;
      current_search_result = data.trees[0];
      search_marked_profile_ids = current_search_result.profile_ids
      current_search_result_profile = current_search_result.profile_ids[0]
      getCircles({profile_id: current_search_result_profile, token: access_token, path_from_profile_id: 13})
      $('#jsdebug').text(JSON.stringify(search_marked_profile_ids))
    });
}
