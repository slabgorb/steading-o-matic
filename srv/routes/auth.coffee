passport = require 'passport'


exports.register_routes = (app) ->

  #
  # sends the request through our local signup strategy, and if
  # successful takes user to homepage, otherwise returns then to
  # signin page
  #
  app.post '/local-reg', passport.authenticate 'local-signup',
    successRedirect: '/'
    failureRedirect: '/signin'

  #
  # sends the request through our local login/signin strategy, and if
  # successful takes user to homepage, otherwise returns then to
  # signin page
  #
  app.post '/login', passport.authenticate 'local-signin',
    successRedirect: '/'
    failureRedirect: '/signin'

  #
  # sign in page
  #
  app.get '/signin', (req, res) ->
    res.render('sign-in')

  #
  # logs user out of site, deleting them from the session, and returns
  # to homepage
  #
  app.get '/logout', (req, res) ->
    name = req.user.username
    console.log 'LOGGING OUT ' + req.user.username
    req.logout()
    res.redirect '/'
    req.session.notice = 'You have successfully been logged out ' + name + '!'
