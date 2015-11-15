class SteadingOMatic.Models.Steading extends SteadingOMatic.Models.Base

  url: -> if @get('_id') then "/api/steadings/#{@get('_id')}" else "/api/steadings"

  initialize: (attributes, options = {}) ->
    options.type ?= 'village'
    super(attributes, options)
    unless attributes._id?
      baseAttributes = switch options.type
        when 'village' then @defaultsForVillage()
        when 'town' then @defaultsForTown()
        when 'city' then @defaultsForCity()
        when 'keep' then @defaultsForKeep()
      baseAttributes.icon = @randomIcon()
      background = @randomColor()
      baseAttributes.description = @randomDescription()
      baseAttributes.colors = {
        background: background
        icon: @contrastingColor(background)
      }
      baseAttributes.name = @randomName()
      @logger.debug "Base attributes", baseAttributes
      @set(baseAttributes)
      @logger.debug "model", @toJSON()
    @set('iconList', SteadingOMatic.Models.Steading.iconList)
    @set('enums', SteadingOMatic.Models.Steading.enums)
    @set('colorList', SteadingOMatic.Models.Steading.colorList)



  #
  # sets defaults for a new village
  #
  defaultsForVillage: ->
    size: 'Village'
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
    size: 'Town'
    prosperity: 'Moderate'
    population: 'Steady'
    defenses: 'Watch'
    tags:
      tag: 'trade', details: ''

  #
  # sets defaults for a new keep
  #
  defaultsForKeep: ->
    size: 'Keep'
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
    size: 'City'
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
    _.sample(_.values(SteadingOMatic.Models.Steading.colorList))

  #
  # selects a random name
  #
  randomName: ->
    _.sample( SteadingOMatic.Models.Steading.namesList )

  randomDescription: ->
    "A randomly generated  #{@get('size')}"

  #
  # chooses a contrasting color for the icon
  #
  contrastingColor: (color) ->
    if @luma(color) >= 165 then '#000000' else '#FFFFFF'

  #
  #  helper function for @contrastingColor
  #
  luma: (color) ->
    rgb = if typeof color == 'string' then @hexToRGBArray(color) else color
    0.2126 * rgb[0] + 0.7152 * rgb[1] + 0.0722 * rgb[2]

  #
  # helper function for @luma
  #
  hexToRGBArray: (color) ->
    color = color.replace('#','')
    rgb = []
    i = 0
    while i <= 2
      rgb[i] = parseInt(color.substr(i * 2, 2), 16)
      i++
    rgb

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


  @namesList = [
    "Graybark"
    "Nook\'s Crossing"
    "Tanner\'s Ford"
    "Goldenfield"
    "Barrowbridge"
    "Rum River"
    "Brindenburg"
    "Shambles"
    "Covaner"
    "Enfield"
    "Crystal Falls"
    "Castle Daunting"
    "Nulty\'s Harbor"
    "Castonshire"
    "Cornwood"
    "Irongate"
    "Mayhill"
    "Pigton"
    "Crosses"
    "Battlemoore"
    "Torsea"
    "Curland"
    "Snowcalm"
    "Seawall"
    "Varlosh"
    "Terminum"
    "Avonia"
    "Bucksburg"
    "Settledown"
    "Goblinjaw"
    "Hammerford"
    "Pit"
    "The Gray Fast"
    "Ennet Bend"
    "Harrison\'s Hold"
    "Fortress Andwynne"
    "Blackstone"
  ]

  @enums =
    prosperity : [
      {
        value:0,
        key:"Dirt",
        description:"Nothing for sale, nobody has more than they need (and they're lucky if they have that). Unskilled labor is cheap."
      }
      {
        value:1,
        key:"Poor",
        description:"Only the bare necessities for sale. Weapons are scarce unless the steading is heavily defended or militant. Unskilled labor is readily available."
      }
      {
        value:2,
        key:"Moderate",
        description:"Most mundane items are available. Some types of skilled laborers."
      }
      {
        value:3,
        key:"Wealthy",
        description:"Any mundane item can be found for sale. Most kinds of skilled laborers are available, but demand is high for their time."
      }
      {
        value:4,
        key:"Rich",
        description:"Mundane items and more, if you know where to find them. Specialist labor available, but at high prices."
      }
    ]

    population:  [
      {
        value:0,
        key:"Exodus",
        description:"The steading has lost its population and is on the verge of collapse."
      }
      {
        value:1,
        key:"Shrinking",
        description:"The population is less than it once was. Buildings stand empty."
      }
      {
        value:2,
        key:"Steady",
        description:"The population is in line with the current size of the steading. Some slow growth."
      }
      {
        value:3,
        key:"Growing",
        description:"More people than there are buildings."
      }
      {
        value:4,
        key:"Booming",
        description:"Resources are stretched thin trying to keep up with the number of people."
      }
    ]

    defenses: [
      {
        value:0,
        key:"None",
        description:" Clubs, torches, farming tools."
      }
      {
        value:1,
        key:"Militia",
        description:"There are able-bodied men and women with worn weapons ready to be called, but no standing force."
      }
      {
        value:2,
        key:"Watch",
        description:"There are a few watchers posted who look out for trouble and settle small problems, but their main role is to summon the militia."
      }
      {
        value:3,
        key:"Guard",
        description:"There are armed defenders at all times with a total pool of less than 100 (or equivalent). There is always at least one armed patrol about the steading."
      }
      {
        value:4,
        key:"Garrison",
        description:"There are armed defenders at all times with a total pool of 100–300 (or equivalent). There are multiple armed patrols at all times."
      }
      {
        value:5,
        key:"Battalion",
        description:"As many as 1,000 armed defenders (or equivalent). The steading has manned maintained defenses as well."
      }
      {
        value:6,
        key:"Legion",
        description:"The steading is defended by thousands of armed soldiers (or equivalent). The steading’s defenses are intimidating. "
      }
    ]


  @colorList = {
    Black:"#000000",
    Navy:"#000080",
    DarkBlue:"#00008B",
    MediumBlue:"#0000CD",
    Blue:"#0000FF",
    DarkGreen:"#006400",
    Green:"#008000",
    Teal:"#008080",
    DarkCyan:"#008B8B",
    DeepSkyBlue:"#00BFFF",
    DarkTurquoise:"#00CED1",
    MediumSpringGreen:"#00FA9A",
    Lime:"#00FF00",
    SpringGreen:"#00FF7F",
    Aqua:"#00FFFF",
    Cyan:"#00FFFF",
    MidnightBlue:"#191970",
    DodgerBlue:"#1E90FF",
    LightSeaGreen:"#20B2AA",
    ForestGreen:"#228B22",
    SeaGreen:"#2E8B57",
    DarkSlateGray:"#2F4F4F",
    LimeGreen:"#32CD32",
    MediumSeaGreen:"#3CB371",
    Turquoise:"#40E0D0",
    RoyalBlue:"#4169E1",
    SteelBlue:"#4682B4",
    DarkSlateBlue:"#483D8B",
    MediumTurquoise:"#48D1CC",
    Indigo :"#4B0082",
    DarkOliveGreen:"#556B2F",
    CadetBlue:"#5F9EA0",
    CornflowerBlue:"#6495ED",
    RebeccaPurple:"#663399",
    MediumAquaMarine:"#66CDAA",
    DimGray:"#696969",
    SlateBlue:"#6A5ACD",
    OliveDrab:"#6B8E23",
    SlateGray:"#708090",
    LightSlateGray:"#778899",
    MediumSlateBlue:"#7B68EE",
    LawnGreen:"#7CFC00",
    Chartreuse:"#7FFF00",
    Aquamarine:"#7FFFD4",
    Maroon:"#800000",
    Purple:"#800080",
    Olive:"#808000",
    Gray:"#808080",
    SkyBlue:"#87CEEB",
    LightSkyBlue:"#87CEFA",
    BlueViolet:"#8A2BE2",
    DarkRed:"#8B0000",
    DarkMagenta:"#8B008B",
    SaddleBrown:"#8B4513",
    DarkSeaGreen:"#8FBC8F",
    LightGreen:"#90EE90",
    MediumPurple:"#9370DB",
    DarkViolet:"#9400D3",
    PaleGreen:"#98FB98",
    DarkOrchid:"#9932CC",
    YellowGreen:"#9ACD32",
    Sienna:"#A0522D",
    Brown:"#A52A2A",
    DarkGray:"#A9A9A9",
    LightBlue:"#ADD8E6",
    GreenYellow:"#ADFF2F",
    PaleTurquoise:"#AFEEEE",
    LightSteelBlue:"#B0C4DE",
    PowderBlue:"#B0E0E6",
    FireBrick:"#B22222",
    DarkGoldenRod:"#B8860B",
    MediumOrchid:"#BA55D3",
    RosyBrown:"#BC8F8F",
    DarkKhaki:"#BDB76B",
    Silver:"#C0C0C0",
    MediumVioletRed:"#C71585",
    IndianRed :"#CD5C5C",
    Peru:"#CD853F",
    Chocolate:"#D2691E",
    Tan:"#D2B48C",
    LightGray:"#D3D3D3",
    Thistle:"#D8BFD8",
    Orchid:"#DA70D6",
    GoldenRod:"#DAA520",
    PaleVioletRed:"#DB7093",
    Crimson:"#DC143C",
    Gainsboro:"#DCDCDC",
    Plum:"#DDA0DD",
    BurlyWood:"#DEB887",
    LightCyan:"#E0FFFF",
    Lavender:"#E6E6FA",
    DarkSalmon:"#E9967A",
    Violet:"#EE82EE",
    PaleGoldenRod:"#EEE8AA",
    LightCoral:"#F08080",
    Khaki:"#F0E68C",
    AliceBlue:"#F0F8FF",
    HoneyDew:"#F0FFF0",
    Azure:"#F0FFFF",
    SandyBrown:"#F4A460",
    Wheat:"#F5DEB3",
    Beige:"#F5F5DC",
    WhiteSmoke:"#F5F5F5",
    MintCream:"#F5FFFA",
    GhostWhite:"#F8F8FF",
    Salmon:"#FA8072",
    AntiqueWhite:"#FAEBD7",
    Linen:"#FAF0E6",
    LightGoldenRodYellow:"#FAFAD2",
    OldLace:"#FDF5E6",
    Red:"#FF0000",
    Fuchsia:"#FF00FF",
    Magenta:"#FF00FF",
    DeepPink:"#FF1493",
    OrangeRed:"#FF4500",
    Tomato:"#FF6347",
    HotPink:"#FF69B4",
    Coral:"#FF7F50",
    DarkOrange:"#FF8C00",
    LightSalmon:"#FFA07A",
    Orange:"#FFA500",
    LightPink:"#FFB6C1",
    Pink:"#FFC0CB",
    Gold:"#FFD700",
    PeachPuff:"#FFDAB9",
    NavajoWhite:"#FFDEAD",
    Moccasin:"#FFE4B5",
    Bisque:"#FFE4C4",
    MistyRose:"#FFE4E1",
    BlanchedAlmond:"#FFEBCD",
    PapayaWhip:"#FFEFD5",
    LavenderBlush:"#FFF0F5",
    SeaShell:"#FFF5EE",
    Cornsilk:"#FFF8DC",
    LemonChiffon:"#FFFACD",
    FloralWhite:"#FFFAF0",
    Snow:"#FFFAFA",
    Yellow:"#FFFF00",
    LightYellow:"#FFFFE0",
    Ivory:"#FFFFF0",
    White:"#FFFFFF"
  }
