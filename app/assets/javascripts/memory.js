$(function() {
  var data = [];
  $('td').keydown(function() {
    data.push(this.id, $(this).html().substr(0, 2)); //position, value
  })
  $('td').blur(function() {
    if ((id_i = data.indexOf(this.id) != -1) && data[id_i+1] != $(this).html().substr(0, 2)) {
      var int_id = this.id.split("-")[1]
      $.post("/memory/update_memory?project="+$(this).closest("table").data("project")+"&file="+Math.floor((int_id/2048)+1)+"&mem_id="+int_id%2048+"&value="+$(this).html().substr(0, 2));
      data.splice(id_i, 2);
    }
  });
  $('select').change(function() {
    $.get("/memory/table?project="+$(this).data("project")+"&file="+$(this).find("option:selected").text()+".hex")
  });
});
    
    
  
