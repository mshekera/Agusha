express = require 'express'

View = require '../lib/view'
Main = require './user/main'
Registration = require './user/registration'
Tour = require './user/tour'

Router = express.Router()

Router.get '/', Main.index

Router.get '/registration', Registration.index
Router.get '/registration/success', Registration.success
Router.get '/registration/success/:id', Registration.success
Router.get '/registration/activate/:salt', Registration.activate

Router.post '/registration/invite', Registration.invite
Router.post '/registration/register', Registration.register

Router.get '/tour', Tour.index
Router.post '/tour/add_record', Tour.add_record

exports.Router = Router