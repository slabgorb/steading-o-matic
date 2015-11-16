bcrypt = require('bcryptjs')
Q = require('q')
config = require('./config.js')
mongoose = require 'mongoose'
User = require('./models/user')

exports.localReg = (username, password) ->
  deferred = Q.defer()
  # check if username is already assigned in our database
  User.findOne {username: username}, (err, result) ->
    console.log 'found user?', result
    if err
      console.log err
      deferred.resolve false
    unless result
      User.create {username: username, password: password}, (err, user) ->
        console.log 'created user'
        if err
          deferred.reject new Error(err)
        deferred.resolve(user)
  deferred.promise

#
# check if user exists
# if user exists check if passwords match (use bcrypt.compareSync(password, hash); // true where 'hash' is password in DB)
# if password matches take into website
# if user doesn't exist or password doesn't match tell them it failed
#

exports.localAuth = (username, password) ->
  console.log "logging in #{username}"
  deferred = Q.defer()
  User.findOne {username: username}, (err, user) ->
    unless user
      console.log 'COULD NOT FIND USER IN DB FOR SIGNIN'
      deferred.resolve false

    console.log 'FOUND USER'
    user.comparePassword password, (err, isMatch) ->
      if err
        deferred.reject new Error(err)
      unless isMatch
        deferred.resolve false
      else
        deferred.resolve user
  deferred.promise
