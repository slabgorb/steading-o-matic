class SteadingOMatic.Views.SteadingForm extends SteadingOMatic.Views.Form

  initialize: (options) ->
    @template = JST["app/templates/steading/form.html"]
    $.getJSON 'json/icons.json', (data) =>
      @iconList = _.sortBy data.icons, (k,v) -> k
      @model.set 'iconList', @iconList
      super(options)
