define({
	router: {
		root: '/',
		modulesContainer: '#modules',
		modules: [
			{
				name: 'main',
				path: {
					client: 'user/main/main',
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
		defaultModule: 'main'
	}
});