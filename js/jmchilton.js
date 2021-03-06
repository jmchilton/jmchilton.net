

$(document).ready(function() {
  $('.collapsable').toggle(
    function() {
      $(this).siblings().slideToggle('slow');
      $(this).removeClass('uncollapsed');
      $(this).addClass('collapsed');
    },
    function() {
      $(this).siblings().slideToggle('slow');
      $(this).removeClass('collapsed');
      $(this).addClass('uncollapsed');
    }
  );
  $('.collapsable').addClass('uncollapsed');

  $("#page-border").corner("6px");
  $("#infoBox .content").corner("tl bl 6px");
  $("#infoBox .border").corner("tl bl 10px");

  $("#shareBox .content").corner("tr br 5px");
  $("#shareBox .border").corner("tr br 8px");


  /*
	   $("#social").fancybox({
          'width': '75%',
              'height': '75%',
              'autoScale'     : false,
              'transitionIn': 'none',
              'transitionOut': 'none',
              'type': 'iframe'
              });
  */


  $(".initially-undisplayed").ticker({
 		cursorList:  " ",
 		rate:        20,
 		delay:       0
	}).trigger("play"); //.trigger("play").trigger("stop");

});

// Technique found @ http://snippets.dzone.com/posts/show/3737
var thecss = new Array();
if(!document.styleSheets) {
  // Do nothing
} else if (document.styleSheets[0].cssRules) {  // Standards Compliant
  thecss = document.styleSheets[0].cssRules;
} else {
  thecss = document.styleSheets[0].rules;  // IE
}
/*
for (i=0;i<thecss.length;i++) {
  if(thecss[i].selectorText.toLowerCase()=='.initially-undisplayed') {
    //thecss[i].style.cssText="display:none;";
  }
}
*/