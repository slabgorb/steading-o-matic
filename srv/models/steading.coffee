mongoose = require 'mongoose'
iconList = require '../icon_list'
_ = require 'underscore'

Schema = mongoose.Schema
SteadingSchema = new Schema
  icon:
    type: String
    enum: _.values(iconList)
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
    background: String
    icon: String
  description: String

module.exports = mongoose.model 'Steading', SteadingSchema
