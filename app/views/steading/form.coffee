class SteadingOMatic.Views.SteadingForm extends SteadingOMatic.Views.Form

  initialize: (options) ->
    @template = JST["app/templates/steading/form.html"]
    super(options)

  events: ->
    _.extend super(),
      'keyup .tag-details': 'eventKeyupTagDetails'
      'click .tag-checkbox': 'eventClickTagCheckbox'
      'click .random': 'eventClickRandom'
      'click .random-symbol': 'eventClickRandomSymbol'
      'change #colors-background': 'eventChangeBackgroundColor'
      'change #colors-icon': 'eventChangeIconColor'
      'change #iconList': 'eventChangeIcon'

  eventChangeBackgroundColor: (event) ->
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

  flash: ($element, callback) ->
    $element.addClass('active', 50)
    callback()
    $element.removeClass('active', 50)

  #
  # set the form fields to a random symbol
  #
  eventClickRandomSymbol: (event) ->
    @flash $(event.target), =>
      symbol = @model.randomSymbol()
      @$('#iconList').selectpicker('val',symbol.icon).trigger('change')
      @$('#colors-icon').val(symbol.colors.icon).trigger('change')
      @$('#colors-background').val(symbol.colors.background).trigger('change')

  #
  # random name
  #
  eventClickRandom: (event) ->
    $target = $(event.target)
    @flash $target, =>
      $input = $target.parent().find('input')
      $input.val(@model.randomName())
