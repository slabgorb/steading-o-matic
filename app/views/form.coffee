class SteadingOMatic.Views.Form extends SteadingOMatic.Views.Base
  tagName: 'div'

  render: (options) ->
    @setElement @template(@model.attributes)

  postRender: (options) ->
    @$(".selectpicker").selectpicker()
    return @

  events: ->
    'click .action-done': 'actionEditDone'
    'click .action-cancel': 'actionCancel'

  actionEditDone: (event) ->
    event.preventDefault()
    form = $(event.target).closest('form')
    serialization = @cleanup(JSON.parse($(form).serializeJSON()))
    @logger.debug 'form submission', serialization
    @model.set(serialization)
    @model.save().done =>
      @model.trigger 'actionEditDone', @model

  actionCancel: (event) ->
    event.preventDefault()
    @model.trigger 'actionEditDone', @model

  cleanup: (formData) -> formData
