var Production_controller = can.Control.extend(
	{
		defaults: {
			
		}
	},
	
	{
		init: function () {
			this.production_block = this.element.find('.production_block');
			this.production = 1;
			this.length = this.production_block.length;
		},
		
		show_production: function() {
			var classname = 'active';
			
			this.production_block.removeClass(classname);
			this.production_block.filter('.production_' + this.production).addClass(classname);
		},
		
		'.production_arrows .left click': function() {
			if(this.production == 1) {
				this.production = this.length;
			} else {
				this.production--;
			}
			
			this.show_production();
		},
		
		'.production_arrows .right click': function() {
			if(this.production == this.length) {
				this.production = 1;
			} else {
				this.production++;
			}
			
			this.show_production();
		}
	}
);

new Production_controller('#production');