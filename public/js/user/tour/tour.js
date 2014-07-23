var base_url = window.location.protocol + '//' + window.location.host;

var Tour_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			this.mapLatLng = new google.maps.LatLng(50.4300000, 30.389388);
			this.akademLatLng = new google.maps.LatLng(50.4648609, 30.3553083);
			this.vishnevoeLatLng = new google.maps.LatLng(50.3948087, 30.3699517);
			
			this.init_map();
		},
		
		init_map: function() {
			var	options = {
					center: this.mapLatLng,
					zoom: 12
				};
			
			this.map = new google.maps.Map(document.getElementById('tour_map'), options);
			
			this.draw_markers();
			this.draw_route();
		},
		
		draw_markers: function() {
			new google.maps.Marker({
				position: this.akademLatLng,
				map: this.map,
				icon: base_url + '/img/user/tour/akadem_marker.png'
			});
			
			new google.maps.Marker({
				position: this.vishnevoeLatLng,
				map: this.map,
				icon: base_url + '/img/user/tour/agusha_marker.png'
			});
		},
		
		draw_route: function() {
			var polylineCoords = [
				this.akademLatLng,
				this.vishnevoeLatLng
			];
			
			var polyline = new google.maps.Polyline({
				path: polylineCoords,
				strokeColor: "#64cb81",
				strokeOpacity: 1.0,
				strokeWeight: 6
			});
			
			polyline.setMap(this.map);
		},
		
		'.step_button click': function(el) {
			var element = $(el),
				val = element.data('step'),
				calendar_block_inside = $('#calendar_block_inside');
			
			calendar_block_inside.find('.step').removeClass('active');
			calendar_block_inside.find('.step_button').removeClass('active');
			calendar_block_inside.find('.step_' + val).addClass('active');
		}
	}
);

new Tour_controller('#tour');