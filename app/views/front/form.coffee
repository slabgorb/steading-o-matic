class SteadingOMatic.Views.FrontForm extends SteadingOMatic.Views.Form
  initialize: (options) ->
    @template = JST["app/templates/front/form.html"]
    super(options)


  events: ->
    _.extend super(),
      'click .add-portent': 'eventAddPortent'
      'click .add-stake': 'eventAddStake'
      'click .add-castMember': 'eventAddCastMember'

  addAnother: (type) ->
    count = @$(".#{type}-list input").count
    @$(".#{type}-list").append("<input class='form-control' name='#{type}[#{count}]' value=''>")


  eventAddPortent: -> @addAnother('portent')

  eventAddStake: -> @addAnother('stake')

  eventAddCastMember: -> @addAnother('cast')
