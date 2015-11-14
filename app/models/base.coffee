class SteadingOMatic.Models.Base extends Backbone.Model
  idAttribute: '_id'

  initialize: (attributes, options) ->
    @logger = new SteadingOMatic.Logger('info', true)
    super(attributes, options)
