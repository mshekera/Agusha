http = require 'http'

express = require 'express'
async = require 'async'
passport = require 'passport'
roles = require 'roles'
crypto = require 'crypto'
_ = require 'underscore'

cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
session = require 'express-session'
methodOverride = require 'method-override' 
multer = require 'multer'
compression = require 'compression'
gzip = require 'connect-gzip'
ECT = require 'ect'

Auth = require '../lib/auth'
# Cache = require '../lib/cache'
View = require '../lib/view'
Admin = require '../lib/admin'
Image = require '../lib/image'
# Logger = require '../lib/logger'
Referrer = require '../lib/referrer'

admin_controller = require '../controllers/admin'
user_controller = require '../controllers/user'

exports.ectRenderer = ectRenderer = ECT
	watch: true
	root: __dirname + '/../views'
	ext: '.ect'
	open: '<?'
	close: '?>'

# jadeOptions =
	# layout: false

sessionParams =
	secret: '4159J3v6V4rX6y1O6BN3ASuG2aDN7q'

routes = () ->
	@use '/', user_controller.Router
	@use '/admin', admin_controller.Router
	@use (err, req, res, next) ->
		if process.env.NODE_ENV isnt 'production'
			console.log err

		res.send 500, 'Something broke, sorry! :('

configure = () ->
	# @set 'views', "#{__dirname}/../views"
	# @set 'view engine', 'jade'
	# @set 'view options', jadeOptions
	
	@set 'view engine', 'ect'
	@engine 'ect', ectRenderer.render
	
	# @use compression
		# threshold: 2048
	# @use gzip.gzip
		# matchType: ///js/image/images/image/img///
	
	@use '/js', express.static "#{__dirname}/../public/js"
	@use '/img', express.static "#{__dirname}/../public/img"
	@use '/attachable', express.static "#{__dirname}/../public/img/admin/attachable"
	@use '/css', express.static "#{__dirname}/../public/css"
	@use '/fonts', express.static "#{__dirname}/../public/fonts"
	@use '/robots.txt', (req, res)->
		res.set 'Content-Type', 'text/plain'
		res.send "User-agent: *\nDisallow: /"
	
	@use '/loaddy_1357.html', (req, res)->
		res.set 'Content-Type', 'text/plain'
		res.send "f69d1b81b9888a5057c327f01ac24ca7a2c80def0c4567c0b40961c2"
	
	@use multer {
		dest: './public/img/uploads/'
		onFileUploadComplete: Image.doResize
	}
	
	# @use ectRenderer.compiler {root: '/views', gzip: true}
	@use View.compiler {root: '/views', gzip: true}
	
	@use Referrer.isGoodReferrer
	# @use Logger.request
	# @use Cache.requestCache
	@use bodyParser()
	@use cookieParser 'LmAK3VNuA6'
	@use session sessionParams
	@use '/admin', passport.initialize()
	@use '/admin', passport.session()
	@use '/admin', Auth.isAuth
	@use methodOverride()
	@use View.globals

exports.init = (callback) ->
	exports.express = app = express()
	exports.server = http.Server app

	configure.apply app
	routes.apply app

	callback null

exports.listen = (port, callback) ->
	exports.server.listen port, callback