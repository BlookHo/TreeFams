var search_btn = $('#search-results-button');
var search_paginator = $('#search_results_paginator');
var search_results;
var search_marked_profile_ids = [];
var current_search_result = 0;
var current_search_resuls_tree_owner_id;



function getCurrentTreeUserId(){
  return search_results.trees[current_search_result].tree_id;
}


function connectTrees(){
  // http://localhost:3000/make_connection_request?user_id_to_connect=tree_owner_id
  var tree_owner_id = getCurrentTreeUserId();
  window.location.href = '/make_connection_request?user_id_to_connect='+tree_owner_id;
}


// http://localhost:3000/api/v1/search/iternal?token=f4bafd62610a75eee1dd28b6aeaebed5

// Поиск похожих в собственом дереве, если результатов нет, запуск глобального поиска
function startSearch(callback){
  $.get( "/api/v1/search/iternal", { token: access_token } )
  .done(function(data){
    if( $.isEmptyObject(data) ){
      getSearchResults( showSearchResultsButton );
    }else{
      window.location.href = '/internal_similars_search';
    }
  });
}

// Получение результатов поиска и отображение на кнопке на домашней странице
function getSearchResults(callback) {
  $.get( "/api/v1/search", { token: access_token } )
   .done(function( data ) {
      search_results = data;
      if (callback){ callback(search_results); }
    });
};




// Показать результаты поиска на большой синей кнопке
showSearchResultsButton = function(search_results){
  if (search_results.total_profiles == 0){
    $('#notify').fadeIn().addClass('animated lightSpeedIn');
    $('#notify').on('click', function(){
      $(this).addClass('animated lightSpeedOut');
    })
  }else{
    $(search_btn).show();
    $(search_btn).text('Найдено '+search_results.total_profiles+' родственников в '+search_results.total_trees+' деревьях');
    $(search_btn).addClass('animated tada');
  }


};





// Показать навигацию по результатам поиска
updateSearchResultPaginator = function(search_results){
  $('#search_results_paginator #total_search_results').text(search_results.total_trees);
  $('#search_results_paginator #current_search_result').text(current_search_result + 1);
  checkNextSearchResult();
  checkPrevSearchResult();
  showSearchResulsAtIndex(current_search_result);
};


showSearchResulsAtIndex = function(index){
  current_result = search_results.trees[index];
  search_marked_profile_ids = current_result.profile_ids;
  current_search_result_profile = current_result.profile_ids[0];
  getCircles({profile_id: current_search_result_profile, token: access_token, path_from_profile_id: current_search_result_profile});
};



checkNextSearchResult = function(){
  if (search_results.total_trees > (current_search_result + 1) ){
    $('#search_results_paginator a.next').removeClass('disabled');
  }else{
    $('#search_results_paginator a.next').addClass('disabled');
  }
};



checkPrevSearchResult = function() {
  if (current_search_result === 0) {
    $('#search_results_paginator a.prev').addClass('disabled');
  }else{
    $('#search_results_paginator a.prev').removeClass('disabled');
  }
};



showPrevSearchResult = function(){
  if (current_search_result !== 0 ){
    current_search_result  = current_search_result - 1;
    updateSearchResultPaginator(search_results);
  }else{
    return false;
    // alert("No previous result!");
  }
};



showNextSearchResult = function(){
  if (search_results.total_trees > (current_search_result + 1) ){
    current_search_result  = current_search_result + 1;
    updateSearchResultPaginator(search_results);
  }else{
    return false;
    // alert("No next result!");
  }
}





showSearchResult = function(){
  $.get( "/api/v1/search", { token: access_token } )
    .done(function( data ) {
      console.log('Search results');
      console.log(data);
      search_results = data.circles;
      current_search_result = data.trees[0];
      search_marked_profile_ids = current_search_result.profile_ids
      current_search_result_profile = current_search_result.profile_ids[0]
      getCircles({profile_id: current_search_result_profile, token: access_token, path_from_profile_id: 38})
      $('#jsdebug').text(JSON.stringify(search_marked_profile_ids))
    });
}
