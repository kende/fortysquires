    $('document').ready(function() {
      navigator.geolocation.getCurrentPosition(
        function(pos) {
          lat  = pos.coords.latitude;
          long = pos.coords.longitude;
	  if ($('#venue_search_lat').length) {
	    $('#venue_search_lat').val(lat);
	  }

	  if ($('#venue_search_long').length) {
	    $('#venue_search_long').val(long);
	  }
       }
     );
   });
