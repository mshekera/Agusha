mongoose = require 'mongoose'
async = require 'async'

opts =
	server: { auto_reconnect: true, primary:null, poolSize: 50 },
	user: process.env.OPENSHIFT_MONGODB_DB_USERNAME || 'admin',
	pass: process.env.OPENSHIFT_MONGODB_DB_PASSWORD || 'jHn42K2p1mK',
	host: 'localhost'
	port: '27017'
	database: process.env.OPENSHIFT_APP_NAME || 'Agusha'
	primary: null


connString = 'mongodb://'+opts.user+":"+opts.pass+"@"+opts.host+":"+opts.port+"/"+opts.database+"?auto_reconnect=true"

if process.env.OPENSHIFT_MONGODB_DB_PASSWORD
	connection_string = opts.user + ':' +
		opts.pass + '@' +
		opts.host + ':' +
		opts.port + '/' +
		opts.database +
		'?auto_reconnect=true'

mongoose.connect connString, opts