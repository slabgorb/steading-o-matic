class SteadingOMatic.Views.SteadingList extends SteadingOMatic.Views.Base
  tagName: 'div'
  className: 'container'
  initialize: (options) ->
    super(options)
    @listenTo @collection, 'add', @addOne
    @collection.fetch()

  addOne: (model) ->
    view = @childViews.push new SteadingOMatic.Views.SteadingItem({ model: model })
    @$el.append(view.render().el)
