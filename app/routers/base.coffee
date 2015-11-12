class SteadingOMatic.Routers.Base extends Backbone.Router
  routes:
    "": "index"
    "steadings": "steadings"


  steadings: ->
    $('#tab-steadings').addClass('active')
    $('.app').html new SteadingOMatic.Views.SteadingList().render().el
