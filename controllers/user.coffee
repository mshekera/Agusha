express = require 'express'

View = require '../lib/view'
Main = require './user/main'
SignUp = require './user/signup'
Tour = require './user/tour'

Router = express.Router()

Router.get '/', Main.index

Router.get '/signup', SignUp.index
Router.get '/signup/success', SignUp.success
Router.get '/signup/success/:id', SignUp.success
Router.get '/signup/activate/:salt', SignUp.activate

Router.post '/signup/invite', SignUp.invite
Router.post '/signup/register', SignUp.register

Router.get '/tour', Tour.index
Router.post '/tour/add_record', Tour.add_record

exports.Router = Router