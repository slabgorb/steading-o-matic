class SteadingOMatic.Collections.Base extends Backbone.Collection
  modelClass: "Base"

  initialize: (options) ->
    @logger = new SteadingOMatic.Logger('info', true)
    @listenTo @, 'actionDuplicate', @duplicate
    @listenTo @, 'actionDelete', @delete

  comparator: 'name'

  duplicate: (model) ->
    duplicate = new @model(model.toJSON())
    duplicate.unset('_id')
    duplicate.save().done =>
      duplicate.fetch().done =>
        @add(duplicate)

  delete: (model) ->
    @remove(model)
    model.destroy()
