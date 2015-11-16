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
LocalStrategy = require 'passport-local'
TwitterStrategy = require 'passport-twitter'
GoogleStrategy = require 'passport-google'
FacebookStrategy = require 'passport-facebook'

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
  err = req.session.error
  msg = req.session.notice
  success = req.session.success
  delete req.session.error
  delete req.session.success
  delete req.session.notice

  if err then res.locals.error = err
  if msg then res.locals.notice = msg
  if success then res.locals.success = success
  next()

app.get '/', (req, res) ->
  res.render 'index'

app.route('/api')
  .get (req, res) =>
    res.json { routes:_.map (_.filter(app._router.stack, (stack) -> 'route' of stack)), (route) -> route }

http.createServer(app).listen app.get('port'), ->
  console.log("Express server listening on port " + app.get('port'))
