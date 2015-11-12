class SteadingOMatic.Views.SteadingForm extends SteadingOMatic.Views.Base

  initialize: (options) ->
    $.getJSON 'json/icons.json', (data) =>
      @iconList = _.sortBy data.icons, (k,v) -> k
      @model.set 'iconList', @iconList
      super(options)
