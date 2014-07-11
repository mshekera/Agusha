express = require 'express'

View = require '../lib/view'

Main = require './admin/main'
Products = require './admin/products'
Ages = require './admin/ages'
Category = require './admin/category'
Certificate = require './admin/certificate'
Clients = require './admin/clients'
Tours = require './admin/tours'
Tour_records = require './admin/tour_records'

Router = express.Router()

#########################

Router.get '/', Main.index
Router.get '/login', Main.login
Router.get '/logout', Main.logout
Router.get '/dashboard', Main.dashboard

Router.post '/login', Main.do_login
#----------------#
Router.get '/products', Products.index
Router.get '/product/create', Products.create
Router.get '/product/edit/:id', Products.get
Router.get '/product/delete/:id', Products.delete

Router.post '/product', Products.save
#----------------#
Router.get '/ages', Ages.index
Router.get '/age/create', Ages.create
Router.get '/age/edit/:id', Ages.get
Router.get '/age/delete/:id', Ages.delete

Router.post '/age', Ages.save
#----------------#
Router.get '/category', Category.index
Router.get '/category/create', Category.create
Router.get '/category/edit/:id', Category.get
Router.get '/category/delete/:id', Category.delete
Router.get '/category/position/:id', Category.position

Router.post '/category', Category.save
Router.post '/category/position', Category.savePosition
#----------------#
Router.get '/certificate', Certificate.index
Router.get '/certificate/create', Certificate.create
Router.get '/certificate/edit/:id', Certificate.get
Router.get '/certificate/delete/:id', Certificate.delete

Router.post '/certificate', Certificate.save
#----------------#
Router.get '/clients', Clients.index
#----------------#
Router.get '/tours', Tours.index
Router.get '/tour/create', Tours.create
Router.get '/tour/edit/:id', Tours.get
Router.get '/tour/delete/:id', Tours.delete

Router.post '/tour', Tours.save
#----------------#
Router.get '/tour_records', Tour_records.index
########################

exports.Router = Router