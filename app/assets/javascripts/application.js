//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require lib
//= require vendor
//= require hamlcoffee
//= require app

var
  afterRender =  function() {
    $('a.action, button').button();
    $('input.location').each(function() {
      var
        autocomplete = new google.maps.places.Autocomplete(this),
        $this = $(this)
      ;
      google.maps.event.addListener(autocomplete, 'place_changed', function() {
        $this.siblings('.location_id').val(autocomplete.getPlace().id);
      });
      $('select.filter').each(function() {
        $(this).multiselect().multiselectfilter();
      })
    });
  },
  showSpinner = function() {
    $('body').append($('<div class="ui-widget-overlay"></div>'));
    $('body').spin({lines: 8, length: 24, width: 12, radius: 18, trail: 50, speed: 1, shadow: true, color: '#ff932b'});
  },
  hideSpinner = function() {
    $('body').spin(false);
    $('.ui-widget-overlay').remove();
  }
;
$(afterRender);
