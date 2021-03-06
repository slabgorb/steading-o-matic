class SteadingOMatic.Collections.Base extends Backbone.Collection
  modelClass: "Base"

  initialize: (options) ->
    @logger = new SteadingOMatic.Logger('info', true)
    @listenTo @, 'actionDuplicate', @duplicate
    @listenTo @, 'actionDelete', @delete
    @listenTo @, 'addNew', @addNew

  comparator: (model) ->
    model.get('ordinal')

  duplicate: (model) ->
    duplicate = new @model(model.toJSON())
    duplicate.unset('_id')
    duplicate.save().done =>
      duplicate.fetch().done =>
        @add(duplicate)

  delete: (model) ->
    @remove(model)
    model.destroy()

  addNew: (type) ->
    model = new @model({}, {type: type})
    model.randomize().done (m) =>
      _.defer => @add m

  updateSort: (ids) ->
    _.each ids, (id, index) =>
      @logger.debug id, @models
      @findWhere('_id': id).set('ordinal', index)
    @save()

  save: (options) ->
    $.ajax @url,
      type: 'PUT'
      data: @toJSON()

    #Backbone.sync('update', @, options)
