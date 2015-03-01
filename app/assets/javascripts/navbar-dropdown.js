$(document).ready(function(){
  $('#navbar-links li').each(function(){
    var $link = $(this),
    $div = $('#' + $link.data('nav-name')),
    div_or_link_is_hovered = false,

    show = function(){
      div_or_link_is_hovered = true;
      $div.slideDown();
      $link.addClass('hovered');
    }

    hide = function(){
      div_or_link_is_hovered = false
      setTimeout(function(){
        if(div_or_link_is_hovered === false){
          $div.slideUp();
          $link.removeClass('hovered');
        };
      }, 100);
    };

    $link.add($div).hover(show, hide);
  });
});
