$(function() {

  $('.md_editor .field_container .preview-button').click(function() {
    if ($(this).data('preview') == 'true') {
      edit($(this));
    } else {
      preview($(this));
    }
  });

  function edit(target) {
    target.data('preview', 'false');
    target.text('Preview');
    target.parent().find('.preview').hide();
    target.parent().find('.editor_field').show();
  }

  function preview(target) {
    target.data('preview', 'true');
    target.text('Edit');
    var prev   = target.parent().find('.preview');
    var editor = target.parent().find('.editor_field')
    prev.html("<i>(Loading ...)</i>");
    prev.show();
    editor.hide()
    if (target.parent().parent().hasClass('mini')) {
      var url = '/tools/render_mini_markdown';
    } else {
      var url = '/tools/render_markdown';
    }
    $.ajax(url, {
      type: 'post',
      data: {text: editor.val()},
      dataType: 'html',
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      },
      success: function(data) {
        prev.html(data);
        prev.find('pre code').each(function(i, e) {
          if ($(this).attr("class")) {
            $(this).parent().attr("lang", $(this).attr("class").replace("hljs", "").trim());
          } else {
            $(this).parent().attr("lang", "(language unknown)");
          }
          hljs.highlightBlock(e);
        });
      },
      error: function(xhr, status, err) {
        prev.html('<i>(Error: ' + status + ')</i><br>' + err);
      }
    });
  }

  var query_history = {};
  $('.md_editor .editor_field').autocomplete({
    wordCount: 1,
    mode: "inner",
    on: {
      query: function(text, callback) {
        if (text.length > 2 && text[0] == "@") {
          text = text.slice(1);
          if (query_history[text]) {
            callback(query_history[text]);
          } else {
            $.ajax("/users/suggestions", {
              type: 'post',
              data: {name: text},
              dataType: 'json',
              headers: {
                'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
              },
              success: function(data) {
                query_history[text] = data;
                callback(data);
              },
              error: function(xhr, status, err) {
                callback([]);
              }
            });
          }
        }
      }
    }
  });

});