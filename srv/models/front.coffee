mongoose = require 'mongoose'

mongoose.set('debug', true)

Schema = mongoose.Schema
FrontSchema = new Schema
  type: {type: String, enum: ['Adventure', 'Campaign'] }
  dangers:
    [
      {
        type: {type: String, enum: ['Ambitious Organizations','Planar Forces','Arcane Enemies','Hordes','Cursed Places'], doom: String}
      }
    ]
  portents: [String]
  stakes: [String]
  cast: [String]
  description: String

module.exports = mongoose.model 'Front', FrontSchema
