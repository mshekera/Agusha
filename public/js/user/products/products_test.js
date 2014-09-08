define([
	'user/core/core',
	'user/products/products'
],
	function(Core, Products) {
		var isReady = can.Deferred(),
			options = {
				isReady: isReady,
				module: {
					name: 'products',
					id: 'products',
					path: {
						client: 'user/products/products',
						server: 'products'
					}
				}
			};
		
		products = new Products('#products', options);
		
		describe("Products", function() {
			it('should have default options', function () {
				
			});
			
			describe('Products should have #after_init as function.', function() {
				it('should have #after_init', function() {
					products.should.be.have.property('after_init');
				});
				
				it('#after_init should be a function', function() {
					products.after_init.should.be.a.Function;
				});
				
				it('#after_init should...', function() {
					
				});
			});
		});
		
		mocha.run();
	}
);