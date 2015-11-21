passport = require 'passport'
async = require 'async'
crypto = require 'crypto'
mongoose = require 'mongoose'
User = require '../models/user'
nodemailer = require 'nodemailer'

exports.register_routes = (app) ->

  #
  # sends the request through our local signup strategy, and if
  # successful takes user to homepage, otherwise returns then to
  # signin page
  #
  app.post '/local-reg', passport.authenticate 'local-signup',
    console.log 'went to local-reg'
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
    res.render('signin')
  #
  # sign in page
  #
  app.get '/register', (req, res) ->
    res.render('localreg')

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

  #
  # forgot password form
  #
  app.get '/forgot', (req, res) ->
    res.render 'forgot', user: req.user

  #
  # forgot password submission
  #
  app.post '/forgot', (req, res, next) ->
    async.waterfall [
      (done) ->
        crypto.randomBytes 20, (err, buf) ->
          token = buf.toString('hex')
          done err, token
      (token, done) ->
        User.findOne { email: req.body.email }, (err, user) ->
          if !user
            #req.session.error 'No account with that email address exists.'
            console.log "could not find account for #{req.body.email}"
            return res.redirect('/forgot')
          user.resetPasswordToken = token
          user.resetPasswordExpires = Date.now() + 3600000
          user.save (err) ->
            done err, token, user
      (token, user, done) ->
        smtpTransport = nodemailer.createTransport 'SMTP',
          service: 'SendGrid'
          auth:
            user: envs('SENDGRID_USERNAME')
            pass: envs('SENDGRID_PASSWORD')
        mailOptions =
          to: user.email
          from: 'slabgorb@gmail.com'
          subject: 'Steading-O-Matic Password Reset'
          text: "You are receiving this because you (or someone else) have requested the reset of the password for your account.\n\nPlease click on the following link, or paste this into your browser to complete the process:\n\nhttp://#{req.headers.host}/reset/#{token}\n\nIf you did not request this, please ignore this email and your password will remain unchanged.\n"
        smtpTransport.sendMail mailOptions, (err) ->
          req.session.notice "An e-mail has been sent to #{user.email} with further instructions."
          done err, 'done'
    ], (err) ->
      if err
        return next(err)
      res.redirect '/forgot'
      return
    return


  #
  # reset from email
  #
  app.get '/reset/:token', (req, res) ->
    User.findOne {
      resetPasswordToken: req.params.token
      resetPasswordExpires: $gt: Date.now()
    }, (err, user) ->
      if !user
        req.flash 'error', 'Password reset token is invalid or has expired.'
        return res.redirect('/forgot')
      res.render 'reset', user: req.user

  #
  # handle the valid reset
  #
  app.post '/reset/:token', (req, res) ->
    async.waterfall [
      (done) ->
        User.findOne {
          resetPasswordToken: req.params.token
          resetPasswordExpires: $gt: Date.now()
        }, (err, user) ->
          if !user
            req.flash 'error', 'Password reset token is invalid or has expired.'
            return res.redirect('back')
          user.password = req.body.password
          user.resetPasswordToken = undefined
          user.resetPasswordExpires = undefined
          user.save (err) ->
            req.logIn user, (err) ->
              done err, user
              return
            return
          return
        return
      (user, done) ->
        smtpTransport = nodemailer.createTransport 'SMTP',
          service: 'SendGrid'
          auth:
            user: envs('SENDGRID_USERNAME')
            pass: envs('SENDGRID_PASSWORD')
        mailOptions =
          to: user.email
          from: 'slabgorb@gmail.com'
          subject: 'Your password has been changed'
          text: 'Hello,\n\n' + 'This is a confirmation that the password for your account ' + user.email + ' has just been changed.\n'
        smtpTransport.sendMail mailOptions, (err) ->
          req.flash 'success', 'Success! Your password has been changed.'
          done err
          return
        return
    ], (err) ->
      res.redirect '/'
      return
    return
