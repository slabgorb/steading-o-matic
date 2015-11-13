class SteadingOMatic.Views.Form extends SteadingOMatic.Views.Base
  tagName: 'div'

  render: (options) ->
    @setElement @template(@model.attributes)
