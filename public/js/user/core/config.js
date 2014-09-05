define({
	router: {
		root: '/',
		modulesContainer: '#modules',
		modules: [
			{
				name: 'index',
				path: {
					client: 'user/index/index',
					server: ''
				}
			}, {
				name: 'products',
				path: {
					client: 'user/products/products',
					server: 'products'
				}
			}
		],
		defaultModule: 'index'
	}
});