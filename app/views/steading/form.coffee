class SteadingOMatic.Views.SteadingForm extends SteadingOMatic.Views.Form

  initialize: (options) ->
    @template = JST["app/templates/steading/form.html"]
    super(options)
