express = require 'express'

View = require '../lib/view'

Main = require './admin/main'
Products = require './admin/products'

Router = express.Router()

#########################

Router.get '/', Main.index
Router.get '/login', Main.login
Router.get '/logout', Main.logout
Router.get '/dashboard', Main.dashboard

Router.post '/login', Main.do_login

Router.get '/products', Products.index
Router.get '/product/:id', Products.get

Router.get '/product/delete/:id', Products.delete

Router.post '/product/:id', Products.save
Router.post '/product', Products.create

Router.get '/ages', Products.index
Router.get '/age/:id', Products.get

Router.get '/age/delete/:id', Products.delete

Router.post '/age/:id', Products.save
Router.post '/age', Products.create
########################

exports.Router = Router