class SteadingOMatic.Views.SteadingList extends SteadingOMatic.Views.Base
  tagName: 'div'
  el: '.app'
  className: 'container'
  initialize: (options) ->
    super(options)
    @collection = new SteadingOMatic.Collections.Steading()
    @listenTo @collection, 'add', @addOne

  addOne: (model) ->
    view = new SteadingOMatic.Views.SteadingItem({ model: model })
    @childViews.push view
    @$el.append(view.render().el)

  render: (options) ->
    super(options)
    @collection.fetch()
