$(function(){
  hljs.initHighlightingOnLoad();
  $('.flash').click(function(){
    $('.flash').animate({
      opacity: 0
    }, 'fast', function(){
      $(this).animate({
        height: 0
      }, 'slow', function(){
        $(this).hide();
      });
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
      });
    });
  }, 4000);
  var pressed = new Array(10);
  var keys    = [38,38,40,40,37,39,37,39,66,65];
  $(document).keydown(function(e) {
    pressed.push(e.keyCode);
    pressed.shift();
    if ( pressed.toString() == keys.toString() ) {
      $('html').css('overflow-x', 'hidden');
      $('body').css('animation', '1s alternate-reverse infinite wiggle');
      $('body').css('-webkit-animation', '1s alternate-reverse infinite wiggle');
      $('img').css('transform', 'rotate(180deg)');
    }
  });
  $('pre code').each(function() {
    if ($(this).attr("class")) {
      $(this).parent().attr("lang", $(this).attr("class").replace("hljs", "").toLowerCase().trim());
    } else {
      $(this).parent().attr("lang", "(language unknown)");
    }
  });

  Ago({
    format: function(time, unit) {
      time = Math.abs(time);
      if (!unit) return "just now";
      if (time === 1) time = (unit[0] == "h") ? "an" : "a";
      var tail = time < 0 ? " ahead" : " ago";
      return time + " " + unit + tail;
    }
  });
});