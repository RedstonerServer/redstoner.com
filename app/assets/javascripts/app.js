$(function(){
    $('.flash').click(function(){
      $('.flash').animate({
        opacity: 0
      }, 'fast', function(){
        $(this).animate({
          height: 0
        }, 'slow', function(){
          $(this).hide();
        })
      });
    });
    setTimeout(function(){
      $('.flash').animate({
        opacity: 0
      }, 3000, function(){
        $(this).animate({
          height: 0
        }, 'slow', function(){
          $(this).hide();
        })
      });
    }, 4000);
})