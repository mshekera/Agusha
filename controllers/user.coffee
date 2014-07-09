express = require 'express'

View = require '../lib/view'
Main = require './user/main'
Registration = require './user/registration'

Router = express.Router()

Router.get '/', Main.index

Router.get '/registration', Registration.index
Router.get '/registration/register', Registration.register
Router.get '/registration/success', Registration.success
Router.get '/registration/invite', Registration.invite

exports.Router = Router