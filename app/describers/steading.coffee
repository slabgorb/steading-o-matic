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

      _.noop()


  tokenizers:
    historicalSubject: -> _sample
      "The battle of <steadingName>",
    historicalAdjective: -> _.sample
      'key'
      'important'
      'trivial'
      'locally famous'
      'infamous'
      'world-renowned'
      'locally infamous'
      'famous'
    steadingName: => @subject.get('name')




  history_events: [
    "The <historicalAdjective> <historicalSubject> happened here <years> ago.

  ]
