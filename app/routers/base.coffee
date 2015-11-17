class SteadingOMatic.Routers.Base extends Backbone.Router

  initialize: (options) ->
    @bind 'all', (trigger, args) ->
      [func, name] = trigger.split(':')
      if func == 'route' and name?
        $('.ntabs').removeClass('active')
        $("#tab-#{name}").addClass('active')

  routes:
    "": "index"
    "steadings": "steadings"
    "fronts": "fronts"

  index: ->
    _.noop()


  steadings: ->
    new SteadingOMatic.Views.SteadingList().render()

  fronts: ->
    new SteadingOMatic.Views.FrontList().render()
