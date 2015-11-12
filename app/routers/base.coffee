class SteadingOMatic.Routers.Base extends Backbone.Router
  routes:
    "": "index"
    "steadings": "steadings"

  execute: (callback, args,name) ->
    console.log route, name, callback
    $('.ntabs').removeClass('active')
    $("#tab-#{name}").addClass('active')
    super(callback, args,name)

  index: ->
    _.noop()


  steadings: ->
    $('.app').html new SteadingOMatic.Views.SteadingList().render().el
