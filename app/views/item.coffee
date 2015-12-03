class SteadingOMatic.Views.Item extends SteadingOMatic.Views.Base

  render: (options) ->
    @setElement @template(@model.attributes)

  events: ->
    'click .action-edit': 'actionEdit'
    'click .action-delete': 'actionDelete'
    'click .action-duplicate': 'actionDuplicate'
    'click .action-expand': 'actionExpand'

  actionEdit: -> @model.trigger 'actionEdit', @model

  actionDelete: -> @model.trigger 'actionDelete', @model

  actionDuplicate: -> @model.trigger 'actionDuplicate', @model

  actionExpand: (event) -> @$('.more-info').toggleClass('collapse')

  remove: () ->
    @logger.debug 'removing el', @$el
    @$el.remove()
