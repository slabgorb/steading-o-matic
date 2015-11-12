window.SteadingOMatic = {}
SteadingOMatic.Models = {}
SteadingOMatic.Views = {}
SteadingOMatic.Collections = {}
SteadingOMatic.Routers = {}


class SteadingOMatic.App
  constructor: ->
    @router = new SteadingOMatic.Routers.Base()
    Backbone.history.start()

$ ->
  window.app = new SteadingOMatic.App()
