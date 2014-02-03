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


  var editor = new EpicEditor({
    container: 'epic',
    textarea: 'epic-textarea',
    basePath: '/assets',
    theme: {
      base: '/base/epiceditor.css',
      preview: '/preview/github.css',
      editor: '/editor/epic-light.css'
    },
    button: {
      bar: true
    },
    autogrow: {
      minHeight: 500
    }
  });
  try {
    editor.load();
  } catch (e) {}
});