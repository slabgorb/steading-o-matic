_ = require('underscore')
mongoose = require 'mongoose'
fs = require 'fs'

mongoose.set('debug', true)

heraldryIcons = _.map fs.readdirSync('public/images/heraldry/360'), (file) ->
  file.split('.')[0]

Schema = mongoose.Schema
SteadingSchema = new Schema
  icon:
    type: String
    enum: heraldryIcons
  size:
    type: String
    enum: ['Village', 'Town', 'City', 'Keep']
  name:
    type: String
  population:
    type: String
    enum: ['Exodus', 'Shrinking', 'Steady', 'Growing', 'Booming']
  prosperity:
    type: String
    enum: ['Dirt', 'Poor', 'Moderate', 'Wealthy', 'Rich']
  defenses:
    type: String
    enum: ['None', 'Militia', 'Watch', 'Guard', 'Garrison', 'Battalion', 'Legion']
  tags: [ {tag: String, details: String } ]
  colors:
    main: String
    secondary: String
  description: String

module.exports = mongoose.model 'Steading', SteadingSchema
