bcrypt = require('bcryptjs')
Q = require('q')
config = require('./config.js')
mongoose = require 'mongoose'
User = require('./models/user')

exports.localReg = (username, password) ->
  deferred = Q.defer()
  hash = bcrypt.hashSync(password, 8)
  user =
    'username': username
    'password': hash
    'avatar': 'http://placepuppy.it/images/homepage/Beagle_puppy_6_weeks.JPG'
  # check if username is already assigned in our database
  db.get('local-users', username).then((result) ->
    # case in which user already exists in db
    console.log 'username already exists'
    deferred.resolve false
    # username already exists
    return
  ).fail (result) ->
    # case in which user does not already exist in db
    console.log result.body
    if result.body.message == 'The requested items could not be found.'
      console.log 'Username is free for use'
      db.put('local-users', username, user).then(->
        console.log 'USER: ' + user
        deferred.resolve user
        return
      ).fail (err) ->
        console.log 'PUT FAIL:' + err.body
        deferred.reject new Error(err.body)
        return
    else
      deferred.reject new Error(result.body)
    return
  deferred.promise

#
# check if user exists
# if user exists check if passwords match (use bcrypt.compareSync(password, hash); // true where 'hash' is password in DB)
# if password matches take into website
# if user doesn't exist or password doesn't match tell them it failed
#

exports.localAuth = (username, password) ->
  deferred = Q.defer()
  User.findOne({username: username}) (err, result) ->
    if err
      console.log 'COULD NOT FIND USER IN DB FOR SIGNIN'
      deferred.resolve false

    console.log 'FOUND USER'
    hash = result.body.password
    console.log hash
    console.log bcrypt.compareSync(password, hash)
    if bcrypt.compareSync(password, hash)
      deferred.resolve result.body
    else
      console.log 'PASSWORDS DO NOT MATCH'
      deferred.resolve false
  deferred.promise
