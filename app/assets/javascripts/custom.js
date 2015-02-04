$(document).ready(function() {
  initializeCarousel();
  $('#catalog').dataTable({
    lengthMenu: [3, 5, 10, 25, 50],
    iDisplayLength: 3,
    aoColumnDefs: [
      {"bSearchable":false, "aTargets":[5]}
    ],
    stateSave: true
  });
  $('#cart-history').dataTable({
    lengthMenu: [3, 5, 10, 25, 50],
    iDisplayLength: 3,
    stateSave: true
  });
  $('#cart').dataTable({
    lengthMenu: [3, 5, 10, 25, 50],
    iDisplayLength: 3,
    stateSave: true
  });
});

$(document).on('page:load', function() {
  initializeCarousel();
  $('#catalog').dataTable({
    lengthMenu: [3, 5, 10, 25, 50],
    iDisplayLength: 3,
    aoColumnDefs: [
      {"bSearchable":false, "aTargets":[5]}
    ],
    stateSave: true
  });
  $('#cart-history').dataTable({
    lengthMenu: [3, 5, 10, 25, 50],
    iDisplayLength: 3,
    stateSave: true
  });
  $('#cart').dataTable({
    lengthMenu: [3, 5, 10, 25, 50],
    iDisplayLength: 3,
    stateSave: true
  });
});

// $('#checkoutCartModal').on('hide', function(e){
//   console.log("aaaa");
//   console.log($('input[id="payment"]').val());
// });



var initializeCarousel = function() {
  $("#isotope-demo").isotope({
    itemSelector: '.item',
    layoutMode: 'fitRows'
  });

  var sync1 = $("#sync1");
  var sync2 = $("#sync2");

  sync1.owlCarousel({
    singleItem : true,
    slideSpeed : 1000,

    pagination: false,
    afterAction : syncPosition,

    responsiveRefreshRate : 200
  });

  sync2.owlCarousel({
    items : 10,
    itemsDesktop      : [1199,10],
    itemsDesktopSmall     : [979,10],
    itemsTablet       : [768,8],
    itemsMobile       : [479,4],
    navigation: false, 
    pagination: false,
    responsiveRefreshRate : 100,

    afterInit : function(el){
      el.find(".owl-item").eq(0).addClass("synced");
    }
  });

  function syncPosition(el){
    var current = this.currentItem;
    $("#sync2")
    .find(".owl-item")
    .removeClass("synced")
    .eq(current)
    .addClass("synced")
    if($("#sync2").data("owlCarousel") !== undefined){
      center(current)
    }
  }

  $("#sync2").on("click", ".owl-item", function(e){
    e.preventDefault();
    var number = $(this).data("owlItem");
    sync1.trigger("owl.goTo",number);
  });

  function center(number){
    var sync2visible = sync2.data("owlCarousel").owl.visibleItems;
    var num = number;
    var found = false;
    for(var i in sync2visible) {
      if(num === sync2visible[i]) {
        var found = true;
      }
    }

    if(found===false){
      if(num>sync2visible[sync2visible.length-1]) {
        sync2.trigger("owl.goTo", num - sync2visible.length+2)
      } else {
        if(num - 1 === -1) {
          num = 0;
        }
        sync2.trigger("owl.goTo", num);
      }
    } else if(num === sync2visible[sync2visible.length-1]) {
      sync2.trigger("owl.goTo", sync2visible[1])
    } else if(num === sync2visible[0]) {
      sync2.trigger("owl.goTo", num-1)
    }
  }

  $(".next").click(function() {
    sync1.trigger('owl.next');
  })
  
  $(".prev").click(function() {
    sync1.trigger('owl.prev');
  })
};

var stringy = "the friendly debug string <3\n";
var a = function() {
  $("#isotope-demo").isotope({ filter: function() {  
  var name = $(this).find(".all-items-name").data("name")
    return name.match( /A/ );
  } })
}
