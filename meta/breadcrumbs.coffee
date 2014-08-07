module.exports = [
	id: 'signup'
	title: 'Регистрация'
	href: '/signup'
,
	id: 'activate'
	title: 'Форма'
	href: '/activate'
	parent_id: 'signup'
,
	id: 'products'
	title: 'Продукты Агуша'
	href: '/products'
,
	id: 'production'
	title: 'О производстве'
	href: '/production'
,
	id: 'tour'
	title: 'Экскурсия'
	parent_id: 'production'
	href: '/tour'
,
	id: 'food'
	title: 'О детском питании'
	href: '/food'
,
	id: 'feeding_up'
	title: 'Основы прикорма'
	parent_id: 'food'
	href: '/feeding_up'
,
	id: 'news'
	title: 'Что новенького'
	href: '/news'
,
	id: 'contacts'
	title: 'Контакты'
	href: '/contacts'
,
	id: 'video'
	title: 'Видео'
	href: '/video'
	parent_id: 'production'
]