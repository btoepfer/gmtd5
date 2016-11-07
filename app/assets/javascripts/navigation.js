var toggle_menu = function(){
  var nav = $('.nav .toggle-nav');
  nav.click(function(e){
    $('.nav .nav-mobile').addClass('style-mobile').slideToggle();
    e.preventDefault();
  });
};

var add_autocomplete = function(source, target) {
  $( "#note_keywords" ).autocomplete({
    source: source,
    delay: 500, 
    minLength: 3,
    select: function( event, ui ) {
      Turbolinks.visit(target+ui.item.id)
      return false;
    }
  }).autocomplete( "instance" )._renderItem = function( ul, item ) {
    return $( "<li>" ).append( "<div><i class='fa fa-file-text-o'>&nbsp;</i>" + item.title+ "</div>" ).appendTo( ul );
  };
}