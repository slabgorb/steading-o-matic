class SteadingOMatic.Views.Form extends SteadingOMatic.Views.Base
  el: '.app'
  render: (options) ->
    @$el.html @template(@model.attributes)
