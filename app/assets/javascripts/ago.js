$.fn.ago = function(callback) {
  units = [
    ['m', 60],
    ['h', 3600],
    ['d', 86400],
    ['w', 604800],
    ['y', 31536000]
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
      unit    = units[ago_unit];
      ago_str = Math.abs(Math.floor(ago_time/unit[1])).toString() + unit[0] + (ago_time < 0 ? " ahead" : " ago");
    } else {
      ago_str = "just now";
    }

    $(this).text(ago_str);
  });
};