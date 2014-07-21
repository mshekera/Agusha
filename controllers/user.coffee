express = require 'express'

View = require '../lib/view'
Main = require './user/main'
SignUp = require './user/signup'
Products = require './user/products'
Tour = require './user/tour'

Router = express.Router()

Router.get '/', Main.index

#

Router.get '/signup', SignUp.index
Router.get '/signup/success', SignUp.success
Router.get '/signup/success/:id', SignUp.success
Router.get '/signup/activate/:salt', SignUp.activate

Router.post '/signup/invite', SignUp.invite
Router.post '/signup/register', SignUp.register

#

Router.get '/products', Products.index
Router.get '/products/:category', Products.index
Router.get '/products/:category/:age', Products.index

Router.post '/products/searchByFilter', Products.searchByFilter

#

Router.get '/tour', Tour.index
Router.post '/tour/add_record', Tour.add_record

exports.Router = Router