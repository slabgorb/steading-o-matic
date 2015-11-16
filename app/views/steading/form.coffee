class SteadingOMatic.Views.SteadingForm extends SteadingOMatic.Views.Form

  initialize: (options) ->
    @template = JST["app/templates/steading/form.html"]
    super(options)

  cleanup: (formData) ->
    formData.tags = _.filter(formData.tags, (tag) -> tag.tag?)
    formData
