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
    var editor = target.parent().find('.editor_field');
    prev.html("<i>(Loading ...)</i>");
    prev.show();
    editor.hide();
    var url = '/tools/render_markdown';
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

  $('.md_editor .editor_field').textcomplete([{
    // match up to 2 words (everything except some special characters)
    // each word can have up to 16 characters (up to 32 total)
    // words must be separated by a single space
    match: /(^|\s)@(([^!"§$%&\/()=?.,;+*@\s]{1,16} ?){0,1}[^!"§$%&\/()=?.,;+*@\s]{1,16})$/,
    search: function (text, callback, match) {
      console.log("Searching " + text);
      text = text.toLowerCase();
      $.ajax("/users/suggestions", {
        type: "post",
        data: {name: text},
        dataType: "json",
        headers: {
          "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content")
        },
        success: function(data) {
          callback(data);
        },
        error: function(xhr, status, err) {
          console.error(err);
          callback([]);
        }
      });
    },
    template: function(user) {
      var name = user[0];
      var ign  = user[1];
      if (name != ign) {
        return name + " <small>(" + ign + ")</small>";
      } else {
        return ign;
      }
    },
    cache: true,
    replace: function (word) {
      return "$1@" + word[1] + " ";
    }
  }], {
    debounce: 300
  });

});