express = require('express')
routes = require('./routes')
http = require('http')
path = require('path')
favicon = require('serve-favicon')
_ = require 'underscore'

app = express()

app.set('port', process.env.PORT || 3010);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(favicon(__dirname + '/../public/favicon.ico'))
app.use(express.static('public'))

app.get('/', routes.index);


http.createServer(app).listen app.get('port'), ->
  console.log("Express server listening on port " + app.get('port'))
