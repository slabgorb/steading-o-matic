class SteadingOMatic.Collections.Steading extends SteadingOMatic.Collections.Base
  url: '/api/steadings'
  model: SteadingOMatic.Models.Steading

  initialize: (options) ->
    super(options)
    @listenTo @, 'addNew', @addNew

  addNew: (type) ->
    model = new @model({}, {type: type})
    model.save()
    model.fetch().done =>
      _.defer => @add model
