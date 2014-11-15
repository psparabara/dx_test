// Instantiate the Bloodhound suggestion engine
var posts = new Bloodhound({
    datumTokenizer: function (datum) {
        return Bloodhound.tokenizers.whitespace(datum.value);
    },
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/search?q=%QUERY',
      filter: function (posts) {
        // Map the remote source JSON array to a JavaScript array
        return $.map(posts, function (post) {
          return {
            title: post.title,
            id: post.id,
            url: post.url
          };
        });
      }
    }
});

// Initialize the Bloodhound suggestion engine
posts.initialize();
 
$(document).on('ready page:load', function() {
  var myTypeahead = $('#navbar-search-post').typeahead({
    highlight: true
  }, {
    displayKey: 'title',
    source: posts.ttAdapter()
  });

  myTypeahead.on('typeahead:selected',function(evt,data){
    window.location.href = data.url;
  });
});