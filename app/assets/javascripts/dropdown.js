$(function(){
  closeAllDropDown();
  $("body").mouseup(function(){
    closeAllDropDown();
  });

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
}

function toggleDropDownMenu(el){
    $(el).next('ul').toggle();
};
