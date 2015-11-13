class SteadingOMatic.Views.Base extends Backbone.View

  initialize: (options) ->
    @childViews = {}
    @logger = new SteadingOMatic.Logger('info', true)
    _.bindAll @, 'preRender', 'render', 'postRender'
    @render = _.wrap @render, (render) =>
      @preRender()
      render()
      @postRender()

  preRender: -> return @
  postRender: -> return @


  events: -> {}
