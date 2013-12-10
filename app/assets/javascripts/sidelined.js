$(document).ready(function(){
  $('#typeahead').typeahead({                              
    name: 'typeahead-players',
    prefetch: '/players/typeahead.json',                                             
    template: [                                                                 
      '<p class="repo-language">{{name}}</p>',                              
      '<p class="repo-name">{{short_name}}</p>'
    ].join(''),                                                                 
    engine: Hogan,
    ttl: 10
  });

  $("#typeahead").on("typeahead:autocompleted", function(e,datum) { 
    $("#hidden_slug").val(datum.slug);
  });

  $("#typeahead").on("typeahead:selected", function(e,datum) { 
    $("#hidden_slug").val(datum.slug);
    var $typeahead = $(this),
    $form = $typeahead.parents('form').first();
    $form.submit();
  });
});
