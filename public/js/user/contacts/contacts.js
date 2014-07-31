var base_url = window.location.protocol + '//' + window.location.host;

var Contacts_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			this.mapLatLng = new google.maps.LatLng(50.4300000, 30.389388);
			this.vishnevoeLatLng = new google.maps.LatLng(50.3856838, 30.3471481);
			
			this.init_plugins();
		},
		
		init_plugins: function() {
			this.init_map();
		},
		
		init_map: function() {
			var	options = {
					center: this.mapLatLng,
					zoom: 12
				};
			
			this.map = new google.maps.Map(document.getElementById('contacts_map'), options);
			
			this.draw_markers();
		},
		
		draw_markers: function() {
			new google.maps.Marker({
				position: this.vishnevoeLatLng,
				map: this.map,
				icon: base_url + '/img/user/tour/agusha_marker.png'
			});
		}
	}
);

new Contacts_controller('#contacts');