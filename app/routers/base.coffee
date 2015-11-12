class SteadingOMatic.Routers.Base extends Backbone.Router
  routes:
    "": "index"
    "steadings": "steadings"


  steadings: ->
    $('#tab-steadings').addClass('active')
    $('.app').html new SteadOMatic.Views.SteadingListView().render().el
