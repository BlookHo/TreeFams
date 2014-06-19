$(function(){
  closeAllDropDown();
  $("body").mouseup(function(){
    closeAllDropDown();
  });
})


function closeAllDropDown(){
  $('.dropdown ul').hide();
}

function toggleDropDownMenu(el){
    $(el).next('ul').toggle();
};
