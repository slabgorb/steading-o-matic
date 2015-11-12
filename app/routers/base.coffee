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
    "steadings/:id": "steading"
    "steadings/:id/edit": "editSteading"


  index: ->
    _.noop()


  steadings: ->
    new SteadingOMatic.Views.SteadingList().render()

  steading: (id) ->
    model = new SteadingOMatic.Models.Steading({id: id})
    new SteadingOMatic.Views.SteadingDetail({model: model}).render()
