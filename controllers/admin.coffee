express = require 'express'

View = require '../lib/view'

Main = require './admin/main.coffee'

Router = express.Router()

Router.get '/', Main.index
Router.get '/login', Main.login
Router.get '/logout', Main.logout
Router.get '/dashboard', Main.dashboard

Router.post '/login', Main.do_login

#Router.get '/translate/lang/edit/:id', Translate.editLang
#Router.post '/translate/lang/update/:id', Translate.updateLang

exports.Router = Router