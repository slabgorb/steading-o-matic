express = require 'express'
http = require 'http'
path = require 'path'
favicon = require 'serve-favicon'
config = require './config'
bodyParser = require 'body-parser'
mongoose = require 'mongoose'
mongoose.set('debug', true)
mongoose.connect config.creds.mongodb_uri
_ = require 'underscore'
fs = require 'fs'

app = express()


# Models


app.set('port', process.env.PORT || 3010);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(favicon(__dirname + '/../public/favicon.ico'))
app.use(express.static('public'))
app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())


fs.readdirSync( __dirname + '/routes').forEach (file) ->
  name = file.substr(0, file.indexOf('.'))
  return if name == 'index'
  require(__dirname + '/routes/' + name).register_routes(app)

app.use (req, res, next) ->
  console.log req.url, req.method
  next()


app.get '/', (req, res) ->
  res.render 'index'

app.route('/api')
  .get (req, res) =>
    res.json { routes:_.map (_.filter(app._router.stack, (stack) -> 'route' of stack)), (route) -> route }

http.createServer(app).listen app.get('port'), ->
  console.log("Express server listening on port " + app.get('port'))
