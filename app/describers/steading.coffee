class SteadingOMatic.Describers.Steading

  constructor: (subject) ->
    @subject = subject

  describe: (options) ->
    super(options)

  wall: ->
    switch @subject.get('type')
      when 'Keep' then
      when 'Village' then
      when 'Town' then
      when 'City' then

  history: ->
    if @steading.hasTag('history')
      @description += historyEvents
      _.noop()


  tokenizers:
    historicalSubject: -> _.sample [
      "battle of <steadingName>"
      "romance between <personName> and <personName>"
      "myth of the <adjective> <noun>"
      "tragedy of <personName>"
      "miracle of the <adjective><noun>"
    ]

    fancyPhrase: ->

    historicalAdjective: -> _.sample [
      'key'
      'important'
      'important'
      'trivial'
      'locally famous'
      'infamous'
      'world-renowned'
      'locally infamous'
      'famous'
      'famous'
      'obscene'
      'mystical'
    ]

    steadingName: => @subject.get('name')
    steadingType: => @subject.get('type')
    yearsAgo: -> _.sample [
      "a short time ago"
      "a long time ago"
      "hundreds of years ago"
      "just recently"
      "in a time nearly forgotten"
      "during the memories of the oldest inhabitants of <steadingName>"
      "before <steadingName> was a <steadingType>"
    ]



  historyEvents: -> _.sample [
    "the <historicalAdjective> <historicalSubject> happened here <yearsAgo>."
  ]
