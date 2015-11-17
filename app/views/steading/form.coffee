class SteadingOMatic.Views.SteadingForm extends SteadingOMatic.Views.Form

  initialize: (options) ->
    @template = JST["app/templates/steading/form.html"]
    super(options)

  events: ->
    _.extend super(),
      'keyup .tag-details': 'eventKeyupTagDetails'
      'click .tag-checkbox': 'eventClickTagCheckbox'

  eventKeyupTagDetails: (event) ->
    $target = $(event.target)
    $target.parent().parent().find('.tag-checkbox').prop('checked', true) if $target.val().length > 0

  eventClickTagCheckbox: (event) ->
    $target = $(event.target)
    if $target.prop('checked')
      $target.parent().parent().find('div.collapse').collapse('show')
