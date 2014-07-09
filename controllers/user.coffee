express = require 'express'

View = require '../lib/view'
Main = require './user/main'
Registration = require './user/registration'

Router = express.Router()

Router.get '/', Main.index

Router.get '/registration', Registration.index
Router.get '/registration/register', Registration.register

exports.Router = Router