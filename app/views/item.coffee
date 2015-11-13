class SteadingOMatic.Views.Item extends SteadingOMatic.Views.Base

  render: (options) ->
    @setElement @template(@model.attributes)
    @

  events: ->
