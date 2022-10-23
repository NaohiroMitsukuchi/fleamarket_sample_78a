$(document).on('turbolinks:load', ()=>{
  itemId = $(location).attr('pathname').replace("/items/", "");
  $("#favoriteBtn").on("click", function(){
    $.ajax({
      url: 'favorite',
      type: 'POST',
      data: {
        id: itemId
      },
      dataType: 'json'
    })
    .done(function(params){
      $(".favoriteNumber").text(params.favorite_number);
      $(".favoriteIcon").toggleClass("fas");
      $(".favoriteIcon").toggleClass("far");
    })
    .fail(function(){
      alert('error');
    })
  });
});