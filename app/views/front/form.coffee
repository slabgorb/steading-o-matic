class SteadingOMatic.Views.FrontForm extends SteadingOMatic.Views.Form
  initialize: (options) ->
    @template = JST["app/templates/front/form.html"]
    super(options)


  events: ->
    _.extend super(),
      'click .add-portent': 'eventAddPortent'
      'click .add-stake': 'eventAddStake'
      'click .add-castMember': 'eventAddCastMember'
      'click .up': 'eventClickUp'
      'click .down': 'eventClickDown'

  addAnother: (type) ->
    count = @$(".#{type}-list input").count
    @$(".#{type}-list").prepend("<input class='form-control' name='#{type}[#{count}]' value=''>")

  #
  # Finds the index number of an input group
  #
  findIndex: ($input) ->
    parseInt($input.attr('name').split('.').replace(/[|]/g, ''))

  #
  # Replaces an index in a input group
  #
  setIndex: ($input, index) ->
    $input.attr('name').replace(/\d+/, index)


  #
  # Swaps the order of two input groups
  #
  swapOrder: (list, index, offset) ->
    if (listIndex + offset) in list
      hold = list[listIndex]
      list[listIndex] = list[listIndex + offset]
      list[listIndex + offset] = hold

  #
  # Responds to a user indication that they wish to move an input
  # within an input group up or down.
  #
  changeOrder: ($target, direction) ->
    $input = $target.closest('input')
    index = @findIndex($input)
    # find all the inputs in that section, reorder the one we are
    # moving up or down, then re-set all the indices for the array of
    # inputs.
    list = _.map $target.parent().find('input'), (input) -> $(input)
    _.each list, ($i, listIndex) =>
      @swapIndex(list, listIndex, -1) if $i.is($input)
    _.each list, ($i, index) =>
      @setIndex $i, index

  # click up event
  eventClickUp: (event) -> @changeOrder($(event.target), -1)

  # click down event
  eventClickDown: (event) -> @chageOrder($(event.target), 1)

  # TODO: maybe abstract this, although it is not too bad as it is.

  # add portal event
  eventAddPortent: -> @addAnother('portent')

  # add stake event
  eventAddStake: -> @addAnother('stake')

  # add cast member event
  eventAddCastMember: -> @addAnother('cast')
