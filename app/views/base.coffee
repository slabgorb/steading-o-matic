class SteadingOMatic.Views.Base extends Backbone.View

  initialize: (options) ->
    @childViews = []
    @logger = new SteadingOMatic.Logger('info', true)
