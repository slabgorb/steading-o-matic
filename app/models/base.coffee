class SteadingOMatic.Models.Base extends Backbone.Model
  idAttribute: '_id'
  className: 'Base'

  initialize: (attributes, options) ->
    @logger = new SteadingOMatic.Logger('info', true)
    @describer = new SteadingOMatic.Describers[@className]
    @set('iconList', @constructor.iconList)
    super(attributes, options)

  #
  # selects a random name
  #
  randomName: (words = {}) ->

    words.patterns ?= @constructor.patterns
    words.nouns ?= @constructor.nouns
    words.startNouns ?= @constructor.startNouns or words.nouns
    words.adjectives ?= @constructor.adjectives
    words.prefixes ?= @constructor.prefixes
    words.suffixes ?= @constructor.suffixes
    words.endNouns ?= @constructor.endNouns or words.nouns
    pattern = _.sample(words.patterns)

    tokens = _.map pattern.split(/([ !@$%^&*\-\(\)\[\]|{}?,.;':"~`])/), (token) ->
      switch token
        when "<prefix>" then _.sample words.prefixes
        when "<suffix>" then _.sample words.suffixes
        when "<plural_noun>" then _.pluralize(_.sample(words.nouns))
        when "<noun>" then _.sample(words.nouns)
        when "<start_noun>" then _.sample words.startNouns
        when "<adjective>" then _.sample words.adjectives
        when "<general_noun>" then _.sample @constructor.nouns
        when "<general_adjective>" then _.sample @constructor.adjectives
        when "<plural_general_noun>" then _.pluralize(_.sample(@constructor.nouns))
        when "<short_adjective>" then _.sample(_.filter(words.adjectives, (adjective) -> adjective.length < 7))
        when "<short_noun>" then _.sample(_.filter(words.nouns, (noun) -> noun.length < 7))
        when "<end_noun>" then _.sample words.endNouns
        else token
    _.titleize tokens.join('').replace(/(.)\1{2,}/, ($0, $1) -> $1 + $1 ).replace(/\|/g, '')

  #
  # selects a random symbol (icon + colors)
  #
  randomSymbol: ->
    icon: @randomIcon()
    colors: @randomColorSet()

  #
  # selects a random icon
  #
  randomIcon: ->
    _.sample(_.values SteadingOMatic.Models.Base.iconList)


  #
  # selects a random color
  #
  randomColor: ->
    _.sample(_.values(SteadingOMatic.Models.Base.colorList))


  #
  # chooses a background and icon color
  #
  randomColorSet: ->
    backgroundColor = @randomColor()
    background: backgroundColor
    icon: @contrastingColor(backgroundColor)

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


  @colorList =
    Black:                "#000000"
    Navy:                 "#000080"
    DarkBlue:             "#00008B"
    MediumBlue:           "#0000CD"
    Blue:                 "#0000FF"
    DarkGreen:            "#006400"
    Green:                "#008000"
    Teal:                 "#008080"
    DarkCyan:             "#008B8B"
    DeepSkyBlue:          "#00BFFF"
    DarkTurquoise:        "#00CED1"
    MediumSpringGreen:    "#00FA9A"
    Lime:                 "#00FF00"
    SpringGreen:          "#00FF7F"
    Aqua:                 "#00FFFF"
    Cyan:                 "#00FFFF"
    MidnightBlue:         "#191970"
    DodgerBlue:           "#1E90FF"
    LightSeaGreen:        "#20B2AA"
    ForestGreen:          "#228B22"
    SeaGreen:             "#2E8B57"
    DarkSlateGray:        "#2F4F4F"
    LimeGreen:            "#32CD32"
    MediumSeaGreen:       "#3CB371"
    Turquoise:            "#40E0D0"
    RoyalBlue:            "#4169E1"
    SteelBlue:            "#4682B4"
    DarkSlateBlue:        "#483D8B"
    MediumTurquoise:      "#48D1CC"
    Indigo :              "#4B0082"
    DarkOliveGreen:       "#556B2F"
    CadetBlue:            "#5F9EA0"
    CornflowerBlue:       "#6495ED"
    RebeccaPurple:        "#663399"
    MediumAquaMarine:     "#66CDAA"
    DimGray:              "#696969"
    SlateBlue:            "#6A5ACD"
    OliveDrab:            "#6B8E23"
    SlateGray:            "#708090"
    LightSlateGray:       "#778899"
    MediumSlateBlue:      "#7B68EE"
    LawnGreen:            "#7CFC00"
    Chartreuse:           "#7FFF00"
    Aquamarine:           "#7FFFD4"
    Maroon:               "#800000"
    Purple:               "#800080"
    Olive:                "#808000"
    Gray:                 "#808080"
    SkyBlue:              "#87CEEB"
    LightSkyBlue:         "#87CEFA"
    BlueViolet:           "#8A2BE2"
    DarkRed:              "#8B0000"
    DarkMagenta:          "#8B008B"
    SaddleBrown:          "#8B4513"
    DarkSeaGreen:         "#8FBC8F"
    LightGreen:           "#90EE90"
    MediumPurple:         "#9370DB"
    DarkViolet:           "#9400D3"
    PaleGreen:            "#98FB98"
    DarkOrchid:           "#9932CC"
    YellowGreen:          "#9ACD32"
    Sienna:               "#A0522D"
    Brown:                "#A52A2A"
    DarkGray:             "#A9A9A9"
    LightBlue:            "#ADD8E6"
    GreenYellow:          "#ADFF2F"
    PaleTurquoise:        "#AFEEEE"
    LightSteelBlue:       "#B0C4DE"
    PowderBlue:           "#B0E0E6"
    FireBrick:            "#B22222"
    DarkGoldenRod:        "#B8860B"
    MediumOrchid:         "#BA55D3"
    RosyBrown:            "#BC8F8F"
    DarkKhaki:            "#BDB76B"
    Silver:               "#C0C0C0"
    MediumVioletRed:      "#C71585"
    IndianRed :           "#CD5C5C"
    Peru:                 "#CD853F"
    Chocolate:            "#D2691E"
    Tan:                  "#D2B48C"
    LightGray:            "#D3D3D3"
    Thistle:              "#D8BFD8"
    Orchid:               "#DA70D6"
    GoldenRod:            "#DAA520"
    PaleVioletRed:        "#DB7093"
    Crimson:              "#DC143C"
    Gainsboro:            "#DCDCDC"
    Plum:                 "#DDA0DD"
    BurlyWood:            "#DEB887"
    LightCyan:            "#E0FFFF"
    Lavender:             "#E6E6FA"
    DarkSalmon:           "#E9967A"
    Violet:               "#EE82EE"
    PaleGoldenRod:        "#EEE8AA"
    LightCoral:           "#F08080"
    Khaki:                "#F0E68C"
    AliceBlue:            "#F0F8FF"
    HoneyDew:             "#F0FFF0"
    Azure:                "#F0FFFF"
    SandyBrown:           "#F4A460"
    Wheat:                "#F5DEB3"
    Beige:                "#F5F5DC"
    WhiteSmoke:           "#F5F5F5"
    MintCream:            "#F5FFFA"
    GhostWhite:           "#F8F8FF"
    Salmon:               "#FA8072"
    AntiqueWhite:         "#FAEBD7"
    Linen:                "#FAF0E6"
    LightGoldenRodYellow: "#FAFAD2"
    OldLace:              "#FDF5E6"
    Red:                  "#FF0000"
    Fuchsia:              "#FF00FF"
    Magenta:              "#FF00FF"
    DeepPink:             "#FF1493"
    OrangeRed:            "#FF4500"
    Tomato:               "#FF6347"
    HotPink:              "#FF69B4"
    Coral:                "#FF7F50"
    DarkOrange:           "#FF8C00"
    LightSalmon:          "#FFA07A"
    Orange:               "#FFA500"
    LightPink:            "#FFB6C1"
    Pink:                 "#FFC0CB"
    Gold:                 "#FFD700"
    PeachPuff:            "#FFDAB9"
    NavajoWhite:          "#FFDEAD"
    Moccasin:             "#FFE4B5"
    Bisque:               "#FFE4C4"
    MistyRose:            "#FFE4E1"
    BlanchedAlmond:       "#FFEBCD"
    PapayaWhip:           "#FFEFD5"
    LavenderBlush:        "#FFF0F5"
    SeaShell:             "#FFF5EE"
    Cornsilk:             "#FFF8DC"
    LemonChiffon:         "#FFFACD"
    FloralWhite:          "#FFFAF0"
    Snow:                 "#FFFAFA"
    Yellow:               "#FFFF00"
    LightYellow:          "#FFFFE0"
    Ivory:                "#FFFFF0"
    White:                "#FFFFFF"


  #
  # static list of icons
  #
  @iconList =
    '\\e007': 'acorn'
    '\\e006': 'antelope-passant'
    'a':      'antelope-rampant-demonic'
    '\\e004': 'antelope-rampant-demonic'
    'b':      'antelope-statant'
    'c':      'ape'
    'e':      'ape-collared-and-chained'
    '\\e036': 'arm-embowed-in-armor'
    '\\e01f': 'arm-habited-and-couped-at-the-elbow'
    'f':      'bat'
    'g':      'bear-passant'
    'h':      'bear-rampant'
    'i':      'bear-sejeant-erect'
    '\\e008': 'bear-statnt'
    'j':      'bears-head-couped'
    '\\e005': 'bears-head-couped-english'
    'k':      'bears-head-erased-and-muzzled'
    'l':      'bee-volant'
    'm':      'boar-passant'
    'n':      'boar-rampant'
    'o':      'boar-statant'
    'p':      'boars-head-couped'
    'q':      'boars-head-erased'
    'r':      'bordure-invected'
    's':      'bordure-nebuly'
    't':      'bordure-potenty'
    'u':      'bordure-wavy'
    'v':      'bucks-head-couped'
    'w':      'bull-passant'
    'x':      'bull-rampant'
    'y':      'bulls-head-caboshed'
    'z':      'catherine-wheel'
    '\\e028': 'censer'
    'A':      'centaur'
    'B':      'chapeau'
    'C':      'chevalier-on-horseback'
    'D':      'cock'
    'E':      'coney-passant'
    'F':      'conquefoil'
    'G':      'coronet'
    '\\e034': 'dog-head'
    'H':      'dolphin-hauriant'
    '\\48':   'dolphin-hauriant'
    'I':      'dolphin-naiant'
    'J':      'ducal-coronet'
    'K':      'eagle-close'
    'L':      'eagle-displayed'
    'M':      'eagle-displayed-wings-inverted'
    'N':      'eagle-double-headed'
    'O':      'eagle-rising'
    'P':      'eagle-rising-wings-addorsed'
    'Q':      'eagle-rising-wings-elevated-addorsed'
    'R':      'eagle-rising-wings-inverted'
    'S':      'eagles-head-couped'
    'T':      'eagles-head-erased'
    'U':      'elephant-and-castle'
    'V':      'enfield'
    '\\e035': 'escallop'
    'W':      'estoile'
    'X':      'falcon'
    'Y':      'fleece'
    'Z':      'fleur-de-lis'
    '0':      'fox-passant'
    '1':      'fox-sejeant'
    '2':      'garb'
    '3':      'goat-salient'
    '\\e033': 'goutte'
    '\\e031': 'hand-dexter'
    '\\e032': 'hand-sinister'
    '4':      'hare-salient'
    '5':      'heraldic-antelope-passant'
    '6':      'heraldic-antelope-rampant'
    '7':      'heraldic-tiger-passant'
    '8':      'heraldic-tiger-rampant'
    '9':      'heron'
    '!':      'hind'
    '"':      'horse-passant'
    '#':      'horse-rampant'
    '\\e030': 'keys'
    '$':      'leopard-head-erased'
    '%':      'leopard-passant'
    '&':      'leopard-rampant'
    '\'':     'leopards-face'
    '\\e02a': 'lion-rampant-regardant'
    '\\e02b': 'lion-salient'
    '\\e02d': 'lion-sejant'
    '\\e02c': 'lion-sejant-regardant-erect'
    '\\e02e': 'lion-sejant-regardant'
    '\\e02f': 'lion-statant'
    '\\e029': 'looped'
    '(':      'lynx-coward'
    ')':      'martlet'
    '*':      'martlet-volant'
    '+':      'mermaid'
    ',':      'merman'
    '-':      'mullet'
    '.':      'mullet-1'
    '/':      'mullet-of-6-points'
    ':':      'mullet-of-points'
    ':':      'mullet-pierced'
    '<':      'oak-tree'
    '=':      'ostrich'
    '>':      'otter'
    '?':      'owl'
    'd':      'pegasus'
    '@':      'pegasus-passant'
    '[':      'pegasus-rampant'
    ']':      'popinjay'
    '^':      'quatrefoil'
    '_':      'ram-rampant'
    '\\e026': 'ram-skull'
    '`':      'ram-statant'
    '{':      'rams-head-caboshed'
    '|':      'raven'
    '}':      'reindeer'
    '~':      'rose'
    '\\':     'rose-slipped-and-leaved'
    '\\e000': 'salmon-hauriant'
    '\\e001': 'salmon-naiant'
    '\\e002': 'sea-horse'
    '\\e024': 'seadog-rampant'
    '\\e023': 'seahog'
    '\\e003': 'serpent-nowed'
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
    '\\e025': 'sword-scimitar'
    '\\e014': 'talbot-passant'
    '\\e015': 'talbot-rampant'
    '\\e016': 'talbot-sejeant'
    '\\e017': 'thistle'
    '\\e022': 'tower'
    '\\e020': 'tower-triple'
    '\\e027': 'trefoil'
    '\\e018': 'wolf-courant'
    '\\e019': 'wolf-passant'
    '\\e01a': 'wolf-rampant'
    '\\e01b': 'wolf-salient'
    '\\e01c': 'wolf-statant'
    '\\e01d': 'yale'
    '\\e01e': 'yale-sejant-erect'
    '\\e021': 'ypotryll'
