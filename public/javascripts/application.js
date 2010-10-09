
function findVenues() {
  $('#venues').html("Loading locations...");

  if (gps_capable()) {
    getLocation(
      function(coords) {
        var lat = coords.latitude;
        var long = coords.longitude;
        $.get('/checkin/nearby_venues?lat=' + lat + '&long=' + long,
              '',
              function(data, status, req) {
                $('#venues').html(data);
              }
        );
      }, function() {
        $('#venues').html("Sorry, we were unable to get your location. <a href='javascript:findVenutes();'>Retry.</a>");
      }
    );
  } else {
    $('#venues').html("Sorry, your browser does not appear to support geolocation.");
  }
}

function gps_capable() {
  var _locator_object;
  try {
    _locator_object = navigator.geolocation;
  } catch (e) {
    return false;
  }

  if (_locator_object) return true; else return false;
}

function getLocation(successCallback, errorCallback) {
  successCallback = successCallback || function(){};
  errorCallback = errorCallback || function(){};

  var geolocation = navigator.geolocation;

  if (geolocation) {
    try {
      function handleSuccess(position) {
	successCallback(position.coords);
      }

      geolocation.getCurrentPosition(handleSuccess, errorCallback, {
	enableHighAccuracy: true,
	maximumAge: 5000 // 5 sec.
      });
    } catch (err) {
      errorCallback();
    }
  } else {
    errorCallback();
  }
}
