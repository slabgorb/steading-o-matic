express = require 'express'
http = require 'http'
path = require 'path'
favicon = require 'serve-favicon'
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
methodOverride = require 'method-override'
mongoose = require 'mongoose'
_ = require 'underscore'
fs = require 'fs'
passport = require 'passport'
LocalStrategy = require 'passport-local'
TwitterStrategy = require 'passport-twitter'
GoogleStrategy = require 'passport-google-oauth'
FacebookStrategy = require 'passport-facebook'
session = require 'express-session'
logger = require 'morgan'
funct = require './functions'
envs = require 'envs'

app = express()

mongoose.set('debug', true)
mongoose.connect envs('MONGODB_URI')

logFile = fs.createWriteStream(__dirname + '/development.log', { flags: 'a' })
morganOptions = {
  stream: logFile
  # skip: function (req, res) { return res.statusCode < 400; }  // uncomment this to log errors only
}

# Models


app.set('port', process.env.PORT || 3010);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(favicon(__dirname + '/../public/favicon.ico'))
app.use(express.static('public'))
app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())
app.use(methodOverride('X-HTTP-Method-Override'))
app.use(session({secret: 'steaings', saveUninitialized: true, resave: true}))
app.use(passport.initialize())
app.use(passport.session())
app.use(logger('combined', morganOptions))


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
  res.render 'index', { user: req.user, foo: 'bar' }

app.route('/api')
  .get (req, res) =>
    res.json { routes:_.map (_.filter(app._router.stack, (stack) -> 'route' of stack)), (route) -> route }

fs.readdirSync( __dirname + '/routes').forEach (file) ->
  name = file.substr(0, file.indexOf('.'))
  return if name == 'index'
  require(__dirname + '/routes/' + name).register_routes(app)


passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (obj, done) ->
  done null, obj


passport.use 'local-signin', new LocalStrategy({ passReqToCallback: true }, (req, email, password, done) ->
  funct.localAuth(email, password).then((user) ->
    if user
      console.log 'LOGGED IN AS: ' + user.email
      req.session.success = 'You are successfully logged in ' + user.email + '!'
      done null, user
    if !user
      console.log 'COULD NOT LOG IN'
      req.session.error = 'Sorry, could not log you in with that email and password.'
      #inform user could not log them in
      done null, user
    return
  ).fail (err) ->
    console.log err.body
    return
  return
)
  # Use the LocalStrategy within Passport to register/"signup" users.
passport.use 'local-signup', new LocalStrategy({ passReqToCallback: true }, (req, email, password, done) ->
  funct.localReg(email, password).then((user) ->
    if user
      console.log 'REGISTERED: ' + user.username
      req.session.success = 'You are successfully registered and logged in ' + user.email + '!'
      done null, user
    if !user
      console.log 'COULD NOT REGISTER'
      req.session.error = 'That email is already in use, please try a different one.'
      done null, user
    return
  ).fail (err) ->
    console.log err.body
    return
  return
)

http.createServer(app).listen app.get('port'), ->
  console.log("Express server listening on port " + app.get('port'))
