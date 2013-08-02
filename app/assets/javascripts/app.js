$(function(){

  $('[data-confirm]').click(function(){
    var c = confirm($(this).attr('data-confirm'));
    if (!c) return false;
  })

    $('#flash').delay(3000).fadeOut('slow');
})