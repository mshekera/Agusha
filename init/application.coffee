http = require 'http'

express = require 'express'
async = require 'async'
passport = require 'passport'
roles = require 'roles'
_ = require 'underscore'
flash = require 'connect-flash'

cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
session = require 'express-session'
methodOverride = require 'method-override' 
multer = require 'multer'
compression = require 'compression'
gzip = require 'connect-gzip'

Auth = require '../lib/auth'
Cache = require '../lib/cache'
View = require '../lib/view'
Admin = require '../lib/admin'

admin_controller = require '../controllers/admin'
user_controller = require '../controllers/user'

jadeOptions =
	layout: false

sessionParams =
	secret: '4159J3v6V4rX6y1O6BN3ASuG2aDN7q'

abideOption =
	supported_languages: ['ru']
	default_lang: 'ru',
	translation_directory: 'locale'
	locale_on_url: false

routes = ()->
	@use user_controller.Router
	@use '/', user_controller.Router
	@use '/admin', admin_controller.Router

configure = () ->
	@set 'views', "#{__dirname}/../views"
	@set 'view engine', 'jade'
	@set 'view options', jadeOptions
	@use compression
		threshold: 2048
	@use gzip.gzip
		matchType: ///js/image/images/image///
	@use '/js', express.static "#{__dirname}/../public/js"
	@use '/images', express.static "#{__dirname}/../public/images"
	@use '/css', express.static "#{__dirname}/../public/css"
	@use '/plugins', express.static "#{__dirname}/../public/plugins"
	@use '/fonts', express.static "#{__dirname}/../public/fonts"
	@use '/robots.txt', (req, res)->
		res.set 'Content-Type', 'text/plain'
		res.send "User-agent: *\nDisallow: /"

	@use Cache.requestCache
	@use bodyParser()
	@use cookieParser 'LmAK3VNuA6'
	@use session sessionParams
	@use flash()
	@use passport.initialize()
	@use passport.session()
	@use '/admin', Auth.isAuth
	@use methodOverride()
	@use View.globals

exports.init = (callback) ->
	exports.express = app = express()
	exports.server = http.Server app

	configure.apply app
	routes.apply app

	callback null

exports.listen = (port, callback)->
	exports.server.listen port, callback


