mongoose = require 'mongoose'
Schema = mongoose.Schema
bcrypt = require 'bcrypt'

SALT_WORK_FACTOR = 10

UserSchema = new Schema(
  username:
    type: String
    required: true
    index: unique: true
  password:
    type: String
    required: true)

UserSchema.pre save, (next) ->
  user = this
  # only hash the password if it has been modified (or is new)
  if !user.isModified('password')
    return next()
  # generate a salt
  bcrypt.genSalt SALT_WORK_FACTOR, (err, salt) ->
    if err
      return next(err)
    # hash the password using our new salt
    bcrypt.hash user.password, salt, (err, hash) ->
      if err
        return next(err)
      # override the cleartext password with the hashed one
      user.password = hash
      next()
      return
    return
  return

UserSchema.methods.comparePassword = (candidatePassword, cb) ->
  bcrypt.compare candidatePassword, @password, (err, isMatch) ->
    if err
      return cb(err)
    cb null, isMatch
    return
  return

module.exports = mongoose.model User, UserSchema
