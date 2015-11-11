#
# this class should be used for debugging purposes
#
class SteadingOMatic.Logger
  constructor: (logLevel = 'info', trace = false, color='Black', bgcolor='White') ->
    @logLevel = logLevel
    @levels = {info: 0, debug: 1, error: 2, fatal: 3, unknown: 4}
    @trace = trace
    @color = color
    @bgcolor = bgcolor



  log: (level, title, messages...) ->
    if @levels[level] >= @levels[@logLevel]
      msg =
      console.groupCollapsed("%c" + title, "color:#{@color}; background-color:#{@bgcolor}", _.last(new Date().toJSON().split("T")).replace('Z',''), @traceline())
      _.each messages, (message) ->
        console.log(message)
      if @trace
        console.groupCollapsed('Trace')
        _.each @traceLines(), (line) -> console.log line
        console.groupEnd('End trace')
      console.groupEnd('')

  info: (title, messages...) ->
    @log('info', title, messages)

  debug: (title, messages...) ->
    @log('debug', title, messages)

  error: (title, messages...) ->
    @log('error', title, messages)

  fatal: (title, messages...) ->
    @log('fatal', title, messages)

  traceline: ->
    err = new Error()
    err.stack.split("\n")[4]

  traceLines: ->
    err = new Error()
    err.stack.split("\n")[4..]
