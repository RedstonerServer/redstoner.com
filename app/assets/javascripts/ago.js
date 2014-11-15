function Ago(nodes, options) {
  nodes = nodes || document.querySelectorAll("time");
  options = options || {};


  var default_opts = {
    interval: 10000, // 10 secs
    units: {
      minute:     60,
      hour:     3600,
      day:     86400,
      week:   604800,
      month: 2592000,
      year: 31536000
    },
    date: function(node) {
      // works on  HTML 'time' nodes
      return new Date(node.dateTime);
    },
    format: "{v} {u} {r}",
    words: {
      now: "just now",
      ago: "ago",
      ahead: "ahead"
    },
    plural: {
      minute: "minutes",
      hour: "hours",
      day: "days",
      week: "weeks",
      month: "months",
      year: "years"
    }
  };

  // override default options
  for (var key in default_opts) {
    options[key] = options[key] || default_opts[key];
  }


  var ago = function(node) {
    // use callback to get date
    var ago_date = options.date(node);
    // get seconds ago
    ago_time = (new Date().getTime() - ago_date.getTime()) / 1000;
    ago_time = Math.floor(Math.abs(ago_time));

    // find greatest unit
    var unit = null;
    var unit_time = null;
    for (var u in options.units) {
      var secs = options.units[u];
      if (ago_time >= secs) {
        unit = u;
        unit_time = secs;
      }
    }

    var output = null;
    if (unit_time !== null) {
      ago_time = Math.floor(ago_time/unit_time);
      // plural
      if (ago_time != 1) unit = options.plural[unit];
      // future or past?
      relative = (ago_time < 0 ? options.words.ahead : options.words.ago);

      output = options.format
        .replace("{v}", ago_time)
        .replace("{u}", unit)
        .replace("{r}", relative);
    } else {
      output = options.words.now;
    }

    node.textContent = output;
  };


  var update_all = function() {
    for (var i = 0; i < nodes.length; i++) {
      ago(nodes[i]);
    }
  };


  update_all();
  setInterval(function() {
    update_all();
  }, options.interval);

}