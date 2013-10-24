$(function(){
  $('.pause-sync-link').bind('click', function(e){
    e.preventDefault();
    var $this = $(this);
    var $row = $this.closest('.row');
    $this.fadeOut();
    $.ajax({
      type: 'DELETE',
      url: this.href,
      success: function(){
        $row.fadeOut();
      }
    });
  });

  $('.resume-sync-link').bind('click', function(e){
    e.preventDefault();
    var $this = $(this);
    var $row = $this.closest('.row');
    $this.fadeOut();
    $.ajax({
      type: 'PUT',
      url: this.href,
      success: function(){
        $row.fadeOut();
      }
    });
  });

  $('.add-space-link').bind('click', function(){
    var data = $(this).data();
    var $form = $(this).closest('form');
    console.log ($(this).closest('.qb-account-ref'));

    data['qb_account_ref'] = $form.find('.qb-account-ref').val();
    console.log(data);
    $.post('/spaces',{space: data}, function(respData, status){
      console.log(respData, status);
      $form.fadeOut();
    });
  });
});

var CobotFb = {
  renderSpaces: function(spaces, knowSpaces){
    var spaceTemplate = $('#spaceTemplate').html();
    var $spaces = $('#spaces');

    var space_id = function(space_url){
      var regex = /api\/spaces\/([\w-]+)/;
      var match = regex.exec(space_url);
      return(match[1]);
    };
    if(spaces.length > 0){
      $.each(spaces, function(){
        this.space_id = space_id(this.space_link);
        var spaceHtml = Mustache.to_html(spaceTemplate, this);
        if(!(knowSpaces.indexOf(this.space_id) > -1)){
          $spaces.append(spaceHtml);
        }
      });
    }else{
      $('#text').text("Seems you don't manage any coworking spaces via cobot.");
    };
  }
};

