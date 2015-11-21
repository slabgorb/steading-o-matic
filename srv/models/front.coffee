mongoose = require 'mongoose'
iconList = require '../icon_list'
_ = require 'underscore'

Schema = mongoose.Schema
FrontSchema = new Schema
  name: String
  type: {type: String, enum: ['Adventure', 'Campaign'] }
  dangers:
    [
      {
        type: {type: String, enum: ['Ambitious Organizations','Planar Forces','Arcane Enemies','Hordes','Cursed Places']}
        doom: String
        name: String
        impulse: String
        description: String
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

module.exports = mongoose.model 'Front', FrontSchema
