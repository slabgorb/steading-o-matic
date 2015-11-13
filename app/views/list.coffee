class SteadingOMatic.Views.List extends SteadingOMatic.Views.Base
  tagName: 'div'
  el: '.app'
  className: 'container'
  itemView: "Item"
  itemCollection: "Base"

  initialize: (options) ->
    super(options)
    @collection = new SteadingOMatic.Collections[@itemCollection]()
    @listenTo @collection, 'add', @addOne
    @listenTo @collection, 'remove', @removeOne

  render: (options) ->
    super(options)
    @collection.fetch()
    @

  addOne: (model) ->
    view = new SteadingOMatic.Views[@itemView]({ model: model })
    @logger.debug 'view', view, view.render().el
    @childViews.push view
    @$el.append(view.render().el)

  removeOne: (model) ->
    view = _.find(@childViews, (child) -> child.model = model)
    @logger.debug 'removing view', view
    view.remove()
