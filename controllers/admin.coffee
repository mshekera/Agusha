express = require 'express'

View = require '../lib/view'

Main = require './admin/main'
Products = require './admin/products'
Ages = require './admin/ages'
Category = require './admin/category'
Certificate = require './admin/certificate'
Clients = require './admin/clients'

Router = express.Router()

#########################

Router.get '/', Main.index
Router.get '/login', Main.login
Router.get '/logout', Main.logout
Router.get '/dashboard', Main.dashboard

Router.post '/login', Main.do_login
#----------------#
Router.get '/products', Products.index
Router.get '/product/:id', Products.get

Router.get '/product/delete/:id', Products.delete

Router.post '/product/:id', Products.save
Router.post '/product', Products.create
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

Router.post '/category', Category.save
#----------------#
Router.get '/certificate', Certificate.index
Router.get '/certificate/create', Certificate.create
Router.get '/certificate/edit/:id', Certificate.get
Router.get '/certificate/delete/:id', Certificate.delete

Router.post '/certificate', Certificate.save
#----------------#
Router.get '/clients', Clients.index
Router.get '/client/:id', Clients.get
########################

exports.Router = Router