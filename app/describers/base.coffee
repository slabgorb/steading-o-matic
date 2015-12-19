class SteadingOMatic.Describers.Base
  constructor: ->
    @logger = new SteadingOMatic.Logger('info', true)

  describe: (subject, options) ->
    _.noop()
