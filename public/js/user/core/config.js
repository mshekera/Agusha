define({
	router: {
		root: '/',
		modulesContainer: '#modules',
		modules: [
			{
				name: 'checker',
				path: {
					client: 'user/checker/checker',
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
		defaultModule: 'checker'
	}
});