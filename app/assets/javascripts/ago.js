$.fn.ago = function(callback) {
  units = { // seconds
    minute:     60,
    //ocd:     100,
    hour:     3600,
    day:     86400,
    week:   604800,
    month: 2592000,
    year: 31536000
  };

  this.each(function() {
    // use the callback or parse time from the node's text
    ago_date = callback ? callback(this) : new Date($(this).text());
    // get seconds ago
    ago_time = (new Date().getTime() - ago_date.getTime()) / 1000;
    ago_time = Math.floor(Math.abs(ago_time));

    // find unit
    var unit_string = null;
    var unit_time   = null;
    for (var unit in units) {
      var secs = units[unit];
      if (ago_time >= secs) {
        unit_string = unit;
        unit_time   = secs;
      } else {
        // we found the greatest unit
        break;
      }
    }

    var ago_str = "just now";
    if (unit_time !== null) {
      ago_time = Math.floor(ago_time/unit_time);
      if (ago_time != 1) unit_string += "s"; // plural
      ago_str  = ago_time.toString() + " " + unit_string;
      // future or past?
      ago_str += (ago_time < 0 ? " ahead" : " ago");
    }

    $(this).text(ago_str);
  });
};