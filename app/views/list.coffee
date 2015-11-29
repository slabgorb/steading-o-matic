class SteadingOMatic.Views.List extends SteadingOMatic.Views.Base
  tagName: 'div'
  el: '.app'
  className: 'container'
  itemView: "Item"
  formView: "Form"
  itemCollection: "Base"

  initialize: (options) ->
    super(options)
    @collection = new SteadingOMatic.Collections[@itemCollection]()
    @listenTo @collection, 'add', @addOne
    @listenTo @collection, 'remove', @removeOne
    @listenTo @collection, 'actionEdit', @editOne
    @listenTo @collection, 'actionEditDone', @showOne

  render: (options) ->
    super(options)
    @collection.fetch()
    @

  postRender: ->
    _.defer => @setSortable()

  setSortable: ->
    @$('.list').sortable
      containment: '.app'
      cursor: 'move'
      cursorAt:
        left: 5
      tolerance: 'touch'
      update: _.bind(@sortStop, @)

  refreshSortable: ->
    @$('.list').sortable('refresh')

  events: ->
    _.extend super(),
      'update': 'sortStop'


  sortStop: (event, ui) ->
    @collection.updateSort(_.map $('.item'), (item) -> $(item).attr('data-id'))

  addOne: (model) ->
    view = new SteadingOMatic.Views[@itemView]({ model: model })
    @childViews[model.cid] = view
    @$('.list').append(view.render().el)
    @setSortable()

  addNew: (model) ->
    view new SteadingOMatic.Views[@formView]({ model: model })
    @childViews[model.cid] = view
    @$('.list').append(view.render().el)

  editOne: (model) ->
    view = new SteadingOMatic.Views[@formView]({ model: model })
    @logger.debug "form", view
    @replaceView(model, view)
    _.defer -> view.postRender()

  showOne: (model) ->
    @replaceView(model, new SteadingOMatic.Views[@itemView]({ model: model }))

  replaceView: (model, view) ->
    oldChild = @childViews[model.cid]
    @childViews[model.cid] = view
    @logger.debug 'rendered view', view.render().el
    @logger.debug "replacing  #item-#{model.get('_id')}"
    @$("#item-#{model.get('_id')}").replaceWith(view.render().el)
    oldChild.remove()

  removeOne: (model) ->
    view = _.find(@childViews, (child) -> child.model = model)
    @logger.debug 'removing view', view
    delete @childViews[model.cid]
    @$("item-#{model.get('_id')}").remove()
    view.remove()
