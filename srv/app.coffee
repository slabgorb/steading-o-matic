express = require 'express'
http = require 'http'
path = require 'path'
favicon = require 'serve-favicon'
mongoose = require 'mongoose'
config = require './config'
bodyParser = require 'body-parser'

_ = require 'underscore'

app = express()

# Models
Steading = require './models/steading'


app.set('port', process.env.PORT || 3010);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(favicon(__dirname + '/../public/favicon.ico'))
app.use(express.static('public'))
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());


app.use (req, res, next) ->
  console.log 'ereiamjh!'
  next()

app.route('/steadings')
  .post (req, res) ->
    steading = new Steading()
    steading.name = req.body.name
    steading.save (err, steading) ->
      res.send(err) if err
      res.json steading
  .get (req, res) ->
    Steading.find (err, steadings) ->
      res.send(err) if err
      res.json steadings


app.get '/', (req, res) ->
  res.render 'index'

http.createServer(app).listen app.get('port'), ->
  console.log("Express server listening on port " + app.get('port'))
