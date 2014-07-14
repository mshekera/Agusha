express = require 'express'

View = require '../lib/view'
Main = require './user/main'
Registration = require './user/registration'
Tour = require './user/tour'

Router = express.Router()

Router.get '/', Main.index

Router.get '/registration', Registration.index
Router.get '/registration/register', Registration.register
Router.get '/registration/success', Registration.success
Router.get '/registration/success/:id', Registration.success
Router.get '/registration/invite', Registration.invite

Router.get '/tour', Tour.index
Router.get '/tour/add_record', Tour.add_record

exports.Router = Router