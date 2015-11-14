class SteadingOMatic.Models.Steading extends SteadingOMatic.Models.Base

  url: -> if @get('_id') then "/api/steadings/#{@get('_id')}" else "/api/steadings"

  initialize: (attributes, options = {}) ->
    options.type ?= 'village'
    super(attributes, options)
    baseAttributes = switch options.type
      when 'village' then @defaultsForVillage()
      when 'town' then @defaultsForTown()
      when 'city' then @defaultsForCity()
      when 'keep' then @defaultForKeep()
    baseAttributes.icon = @randomIcon()
    baseAttributes.color =
      base: @randomColor()
      secondary: @randomColor()
    @logger.debug "Base attributes", baseAttributes
    @set(_.extend(baseAttributes, attributes))
    @set('iconList', SteadingOMatic.Models.Steading.iconList)
    @set('enums', SteadingOMatic.Models.Steading.enums)
    @set('colors', SteadingOMatic.Models.Steading.colors)


  #
  # load some useful data into static variables
  #
  [@enums, @names, @colors]  = _.all([@enums, @names, @colors]) or $.ajax
    url: 'json/steading.json'
    async: false
    success: (data) ->  [data.enums, data.names, data.colors]

  #
  # sets defaults for a new village
  #
  defaultsForVillage: ->
    prosperity: 'Poor'
    population: 'Steady'
    defenses: 'Militia'
    tags:
      tag: 'resource', details: ''
      tag: 'oath', details: ''

  #
  # sets defaults for a new town
  #
  defaultsForTown: ->
    prosperity: 'Moderate'
    population: 'Steady'
    defenses: 'Watch'
    tags:
      tag: 'trade', details: ''

  #
  # sets defaults for a new keep
  #
  defaultsForKeep: ->
    prosperity: 'Poor'
    population: 'Shrinking'
    defenses: 'Guard'
    tags:
      tag: 'trade', details: ''
      tag: 'oath', details: ''

  #
  # sets defaults for a new city
  #
  defaultsForCity: ->
    prosperity: 'Moderate'
    population: 'Steady'
    defenses: 'Guard'
    tags:
      tag: 'oath', details: ''
      tag: 'guild', details: ''
      tag: 'market', details: ''

  #
  # selects a random icon
  #
  randomIcon: ->
    _.sample(_.values SteadingOMatic.Models.Steading.iconList)

  #
  # selects a random set of colors
  #
  randomColor: ->
    _.sample(_.values SteadingOMatic.Models.Steading.colors)

  #
  # static list of icons
  #
  @iconList =
    'a': 'antelope-rampant-demonic'
    'b': 'antelope-statant'
    'c': 'ape'
    'd': 'pegasus'
    'e': 'ape-collared-and-chained'
    'f': 'bat'
    'g': 'bear-passant'
    'h': 'bear-rampant'
    'i': 'bear-sejeant-erect'
    'j': 'bears-head-couped'
    'k': 'bears-head-erased-and-muzzled'
    'l': 'bee-volant'
    'm': 'boar-passant'
    'n': 'boar-rampant'
    'o': 'boar-statant'
    'p': 'boars-head-couped'
    'q': 'boars-head-erased'
    'r': 'bordure-invected'
    's': 'bordure-nebuly'
    't': 'bordure-potenty'
    'u': 'bordure-wavy'
    'v': 'bucks-head-couped'
    'w': 'bull-passant'
    'x': 'bull-rampant'
    'y': 'bulls-head-caboshed'
    'z': 'catherine-wheel'
    'A': 'centaur'
    'B': 'chapeau'
    'C': 'chevalier-on-horseback'
    'D': 'cock'
    'E': 'coney-passant'
    'F': 'conquefoil'
    'G': 'coronet'
    'H': 'dolphin-hauriant'
    'I': 'dolphin-naiant'
    'J': 'ducal-coronet'
    'K': 'eagle-close'
    'L': 'eagle-displayed'
    'M': 'eagle-displayed-wings-inverted'
    'N': 'eagle-double-headed'
    'O': 'eagle-rising'
    'P': 'eagle-rising-wings-addorsed'
    'Q': 'eagle-rising-wings-elevated-addorsed'
    'R': 'eagle-rising-wings-inverted'
    'S': 'eagles-head-couped'
    'T': 'eagles-head-erased'
    'U': 'elephant-and-castle'
    'V': 'enfield'
    'W': 'estoile'
    'X': 'falcon'
    'Y': 'fleece'
    'Z': 'fleur-de-lis'
    '0': 'fox-passant'
    '1': 'fox-sejeant'
    '2': 'garb'
    '3': 'goat-salient'
    '4': 'hare-salient'
    '5': 'heraldic-antelope-passant'
    '6': 'heraldic-antelope-rampant'
    '7': 'heraldic-tiger-passant'
    '8': 'heraldic-tiger-rampant'
    '9': 'heron'
    '!': 'hind'
    '"': 'horse-passant'
    '#': 'horse-rampant'
    '$': 'leopard-head-erased'
    '%': 'leopard-passant'
    '&': 'leopard-rampant'
    '\'': 'leopards-face'
    '(': 'lynx-coward'
    ')': 'martlet'
    '*': 'martlet-volant'
    '+': 'mermaid'
    ',': 'merman'
    '-': 'mullet'
    '.': 'mullet-1'
    '/': 'mullet-of-6-points'
    ':': 'mullet-of-points'
    ':': 'mullet-pierced'
    '<': 'oak-tree'
    '=': 'ostrich'
    '>': 'otter'
    '?': 'owl'
    '@': 'pegasus-passant'
    '[': 'pegasus-rampant'
    ']': 'popinjay'
    '^': 'quatrefoil'
    '_': 'ram-rampant'
    '`': 'ram-statant'
    '{': 'rams-head-caboshed'
    '|': 'raven'
    '}': 'reindeer'
    '~': 'rose'
    '\\': 'rose-slipped-and-leaved'
    '\\e000': 'salmon-hauriant'
    '\\e001': 'salmon-naiant'
    '\\e002': 'sea-horse'
    '\\e003': 'serpent-nowed'
    '\\e004': 'antelope-rampant-demonic'
    '\\e005': 'bears-head-couped-english'
    '\\e006': 'antelope-passant'
    '\\e007': 'acorn'
    '\\e008': 'bear-statnt'
    '\\e009': 'sheep-passant'
    '\\e00a': 'ship-under-sail'
    '\\e00b': 'sphinx'
    '\\e00c': 'squirrel'
    '\\e00d': 'stag-at-gaze'
    '\\e00e': 'stag-lodged'
    '\\e00f': 'stag-springing'
    '\\e010': 'stag-statant'
    '\\e011': 'stag-trippant'
    '\\e012': 'sun-in-splendor'
    '\\e013': 'swan'
    '\\e014': 'talbot-passant'
    '\\e015': 'talbot-rampant'
    '\\e016': 'talbot-sejeant'
    '\\e017': 'thistle'
    '\\e018': 'wolf-courant'
    '\\e019': 'wolf-passant'
    '\\e01a': 'wolf-rampant'
    '\\e01b': 'wolf-salient'
    '\\e01c': 'wolf-statant'
    '\\e01d': 'yale'
    '\\e01e': 'yale-sejant-erect'
