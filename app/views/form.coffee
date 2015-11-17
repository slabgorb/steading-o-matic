class SteadingOMatic.Views.Form extends SteadingOMatic.Views.Base
  tagName: 'div'

  render: (options) ->
    @setElement @template(@model.attributes)

  postRender: (options) ->
    @$(".selectpicker").selectpicker()
    return @

  events: ->
    'click .action-done': 'actionEditDone'

  actionEditDone: (event) ->
    event.preventDefault()
    form = $(event.target).parent('form')
    @logger.debug form
    serialization = @cleanup(JSON.parse($(form).serializeJSON()))
    @logger.debug 'form submission', serialization
    @model.set(serialization)
    @model.save().done =>
      @model.trigger 'actionEditDone', @model


  cleanup: (formData) -> formData
