$.fn.ago = function(callback) {
  units = [
    ['minute', 60],
    ['hour', 3600],
    ['day', 86400],
    ['week', 604800],
    ['year', 31536000]
  ];
  this.each(function() {
    ago_date = callback ? callback(this) : new Date($(this).text());
    ago_time = Math.floor((new Date().getTime() - ago_date.getTime())/1000);
    ago_unit = null;
    units.forEach(function(time, i) {
      if (Math.abs(ago_time) >= time[1]) {
        ago_unit = i;
      } else {
        // we found the greatest unit
        return;
      }
    });

    if (ago_unit !== null) {
      unit     = units[ago_unit];
      ago_time = Math.abs(Math.floor(ago_time/unit[1]))
      ago_str  = ago_time.toString() + " " + unit[0]
      if (ago_time != 1) {
        ago_str += "s";
      }
      ago_str += (ago_time < 0 ? " ahead" : " ago");
    } else {
      ago_str = "just now";
    }

    $(this).text(ago_str);
  });
};