bcrypt = require('bcryptjs')
Q = require('q')
mongoose = require 'mongoose'
User = require('./models/user')

exports.localReg = (email, password) ->
  console.log "Attempting to register #{email}"
  deferred = Q.defer()
  # check if username is already assigned in our database
  User.findOne {email: email}, (err, result) ->
    console.log 'found user?', result
    if err
      console.log err
      deferred.resolve false
    unless result
      User.create {email: email, password: password}, (err, user) ->
        console.log 'created user'
        if err
          deferred.reject new Error(err)
        deferred.resolve(user)
  deferred.promise

exports.localAuth = (email, password) ->
  console.log "logging in #{email}"
  deferred = Q.defer()
  User.findOne {email: email}, (err, user) ->
    unless user
      console.log 'COULD NOT FIND USER IN DB FOR SIGNIN'
      deferred.resolve false
    else
      user.comparePassword password, (err, isMatch) ->
        if err
          deferred.reject new Error(err)
        unless isMatch
          deferred.resolve false
        else
          deferred.resolve user
  deferred.promise
