class SteadingOMatic.Views.SteadingItem extends SteadingOMatic.Views.Base
  initialize: (options) ->
    @template = JST['app/templates/steading/item.html']

  render: ->
    @setElement @template(@model.attributes)
    @
