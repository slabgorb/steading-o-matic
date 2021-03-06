mongoose = require 'mongoose'
patcher = require 'mongoose-json-patch'
iconList = require '../icon_list'
_ = require 'underscore'

Schema = mongoose.Schema
FrontSchema = new Schema
  name: String
  user: {type: mongoose.Schema.Types.ObjectId, ref: 'User'},
  type: {type: String, enum: ['Adventure', 'Campaign'] }
  dangers:
    [
      {
        type: {type: String, enum: ['Ambitious Organizations','Planar Forces','Arcane Enemies','Hordes','Cursed Places']}
        subtype: String
        doom: String
        name: String
        impulse: String
        description: String
        moves: [String]
        icon:
          type: String
          enum: _.values(iconList)
        colors:
          background: String
          icon: String
      }
    ]
  portents: [String]
  stakes: [String]
  cast: [String]
  description: String
  ordinal: Number

FrontSchema.plugin patcher

module.exports = mongoose.model 'Front', FrontSchema
