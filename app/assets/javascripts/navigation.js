var toggle_menu = function(){
  var nav = $('.nav .toggle-nav');
  nav.click(function(e){
    $('.nav .nav-mobile').addClass('style-mobile').slideToggle('slow');
    e.preventDefault();
  });
};