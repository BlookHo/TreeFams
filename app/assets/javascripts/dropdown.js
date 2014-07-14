$(function(){

  $('.path-search-list li').on('click', function(){
    $('.path-search-list li').removeClass('active');
    $(this).addClass('active');
  })


})

$(function(){
  closeAllDropDown();


  $(document).on('click', function(e){

      if( $('.dropdown').has(e.target).length === 0 ){
          if ( $('.ui-autocomplete').has(e.target).length === 0 ){
            closeAllDropDown();
          }
      }
    });


   $('#alive').change(function() {
       $('#death_date_wrapper').toggle();
   });

})



function closeAllDropDown(){
  $('.dropdown ul').hide();
  $('.relation_list').hide();
}


function toggleDropDownMenu(el){
    closeAllDropDown();
    $(el).next('ul').toggle();
};


function toggleDropDownMenuForProfile(profile_element_id){
    closeAllDropDown();
    $(profile_element_id + ' ul.dropdown-content').toggle();
};
