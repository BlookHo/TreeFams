$(function(){
  closeAllDropDown();

  // $("html").click(function(){
  //   closeAllDropDown();
  // });

  $(document).on('click', function(e){
      if($('.dropdown').has(e.target).length === 0){
          closeAllDropDown();
      }
    });

  // $('.dropdown').click(function(event){
  //   // event.stopPropagation();
  //   event.stopImmediatePropagation();
  // });

   $('#alive').change(function() {
       $('#death_date_wrapper').toggle();
        // if($(this).is(":checked")) {
        //     var returnVal = confirm("Are you sure?");
        //     $(this).attr("checked", returnVal);
        // }
        // $('#alive').val($(this).is(':checked'));
    });

})


function closeAllDropDown(){
  $('.dropdown ul').hide();
  $('.relation_list').hide();
}

function toggleDropDownMenu(el){
    $(el).next('ul').toggle();
};
