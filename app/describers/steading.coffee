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
    timeAgo: -> _.sample [
      "a short time ago"
      "a long time ago"
      "hundreds of years ago"
      "just recently"
      "in a time nearly forgotten"
      "during the memories of the oldest inhabitants of <steadingName>"
      "before <steadingName> was a <steadingType>"
      "a very long time ago"
      "in the past"
    ]



  historyEvents: -> _.sample [
    "the <historicalAdjective> <historicalSubject> happened here <timeAgo>."
    "<timeAgo>, the <historicalSubject> happened nearby."
  ]


  @suffixes = [
    'borough'
    'bridge'
    'burg'
    'burn'
    'cross'
    'dale'
    'end'
    'ey'
    'field'
    'ford'
    'gate'
    'green'
    'ham'
    'harbor'
    'hill'
    'hold'
    'ing'
    'ingley'
    'ington'
    'land'
    'lea'
    'leagh'
    'lin'
    'moor'
    'more'
    'port'
    'river'
    'stone'
    'sty'
    'thorpe'
    'ton'
    'ton'
    'town'
    'town'
    'ville'
    'ville'
    'wick'
    'wood'
    'worth'
    'yard'
  ]

  @prefixes = [
    'south'
    'north'
    'east'
    'west'
    'south'
    'north'
    'east'
    'west'
    'upper'
    'lower'
    'old'
    'new'
    'northeast'
    'northwest'
    'southeast'
    'southwest'
  ]

  @endNouns = [
    'crossing'
    'field'
    'bend'
    'road'
    'town'
    'town'
    'city'
    'city'
    'green'
    'yard'
    'head'
    'harbor'
    'port'
   ]
