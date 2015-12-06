class SteadingOMatic.Views.SteadingForm extends SteadingOMatic.Views.Form

  initialize: (options) ->
    @template = JST["app/templates/steading/form.html"]
    super(options)

  events: ->
    _.extend super(),
      'keyup .tag-details': 'eventKeyupTagDetails'
      'click .tag-checkbox': 'eventClickTagCheckbox'
      'click .random': 'eventClickRandom'
      'change #colors-background': 'eventChangeBackgroundColor'
      'change #colors-icon': 'eventChangeIconColor'
      'change #iconList': 'eventChangeIcon'

  eventChangeBackgroundColor: (event) ->
    console.log 'ereiamjh'
    @$('.display-icon').css('background-color', $(event.target).val())

  eventChangeIconColor: (event) ->
    @$('.display-icon').css('color', $(event.target).val())

  eventChangeIcon: (event) ->
    @$('.display-icon').attr('class', 'display-icon').addClass("icon-#{$(event.target).val()}")

  eventKeyupTagDetails: (event) ->
    $target = $(event.target)
    $target.parent().parent().find('.tag-checkbox').prop('checked', true) if $target.val().length > 0

  eventClickTagCheckbox: (event) ->
    $target = $(event.target)
    if $target.prop('checked')
      $target.parent().parent().find('div.collapse').collapse('show')
  cleanup: (formData) ->
    formData.tags = _.filter(formData.tags, (tag) -> tag.tag?)
    formData


  eventClickRandom: (event) ->
    $target = $(event.target)
    $target.addClass('active', 50)
    $input = $target.parent().find('input')
    $input.val(@model.randomName())
    $target.removeClass('active', 50)
