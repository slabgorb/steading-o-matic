class SteadingOMatic.Models.Base extends Backbone.Model
  idAttribute: '_id'

  initialize: (attributes, options) ->
    @logger = new SteadingOMatic.Logger('info', true)
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

  #
  # static list of icons
  #
  @iconList =
    '\\e007': 'acorn'
    '\\e006': 'antelope-passant'
    '\\e004': 'antelope-rampant-demonic'
    'a': 'antelope-rampant-demonic'
    'b': 'antelope-statant'
    'c': 'ape'
    'e': 'ape-collared-and-chained'
    '\\e036': 'arm-embowed-in-armor'
    '\\e01f': 'arm-habited-and-couped-at-the-elbow'
    'f': 'bat'
    'g': 'bear-passant'
    'h': 'bear-rampant'
    'i': 'bear-sejeant-erect'
    '\\e008': 'bear-statnt'
    'j': 'bears-head-couped'
    '\\e005': 'bears-head-couped-english'
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
    '\\e028': 'censer'
    'A': 'centaur'
    'B': 'chapeau'
    'C': 'chevalier-on-horseback'
    'D': 'cock'
    'E': 'coney-passant'
    'F': 'conquefoil'
    'G': 'coronet'
    '\\e034': 'dog-head'
    'H': 'dolphin-hauriant'
    '\\48': 'dolphin-hauriant'
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
    '\\e035': 'escallop'
    'W': 'estoile'
    'X': 'falcon'
    'Y': 'fleece'
    'Z': 'fleur-de-lis'
    '0': 'fox-passant'
    '1': 'fox-sejeant'
    '2': 'garb'
    '3': 'goat-salient'
    '\\e033': 'goutte'
    '\\e031': 'hand-dexter'
    '\\e032': 'hand-sinister'
    '4': 'hare-salient'
    '5': 'heraldic-antelope-passant'
    '6': 'heraldic-antelope-rampant'
    '7': 'heraldic-tiger-passant'
    '8': 'heraldic-tiger-rampant'
    '9': 'heron'
    '!': 'hind'
    '"': 'horse-passant'
    '#': 'horse-rampant'
    '\\e030': 'keys'
    '$': 'leopard-head-erased'
    '%': 'leopard-passant'
    '&': 'leopard-rampant'
    '\'': 'leopards-face'
    '\\e02a': 'lion-rampant-regardant'
    '\\e02b': 'lion-salient'
    '\\e02d': 'lion-sejant'
    '\\e02e': 'lion-sejant-regardant'
    '\\e02c': 'lion-sejant-regardant-erect'
    '\\e02f': 'lion-statant'
    '\\e029': 'looped'
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
    'd': 'pegasus'
    '@': 'pegasus-passant'
    '[': 'pegasus-rampant'
    ']': 'popinjay'
    '^': 'quatrefoil'
    '_': 'ram-rampant'
    '\\e026': 'ram-skull'
    '`': 'ram-statant'
    '{': 'rams-head-caboshed'
    '|': 'raven'
    '}': 'reindeer'
    '~': 'rose'
    '\\': 'rose-slipped-and-leaved'
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

  @adjectives = ["abated", "absolute", "abysmal", "abyssal",
                "accidental", "ace", "aching", "acrid", "admired", "adorable",
                "adventurous", "afflicted", "ageless", "alchemical", "allied",
                "amazing", "amber", "ambiguous", "amethyst", "amusing", "ancient",
                "angelic", "angry", "anguished", "aqua", "aquamarine", "ardent",
                "armored", "artificial", "ashen", "ashamed", "assaulted", "auburn",
                "autonomous", "autumnal", "awe", "azure", "bad", "balanced", "bald",
                "banded", "barbarous", "barricaded", "basic", "bearded", "beautiful",
                "beige", "beloved", "belted", "bent", "bewildering", "bewitched",
                "big", "bitter", "black", "blameless", "blanketed", "blighted",
                "blind", "bloated", "blockaded", "bloody", "blotted", "blowing",
                "blue", "blunt", "bold", "boring", "boyish", "braided", "branded",
                "brash", "brass", "brave", "brazen", "bridled", "bright", "brilliant",
                "bronze", "brown", "brushed", "brutal", "buff", "bulbous", "busy",
                "buttery", "calamitous", "calm", "cardinal", "carmine", "carnal",
                "cavernous", "celebrated", "certain", "cerulean", "charcoal",
                "chartreuse", "chaste", "cheerful", "chestnut", "chocolate", "chunky",
                "cinnamon", "circular", "circumstantial", "clean", "clear",
                "climactic", "closed", "cloudy", "coastal", "cobalt", "coincidental",
                "cold", "colorless", "combined", "comedic", "common", "competitive",
                "complex", "confident", "confining", "confusing", "connected",
                "considerate", "constructive", "contained", "contemptible",
                "contested", "contingent", "convenient", "cooperative", "copper",
                "corrupt", "courageous", "courteous", "cradled", "craterous",
                "crazed", "crazy", "creamy", "creative", "creepy", "cremated",
                "crested", "crewed", "crimson", "cross", "crowded", "cruel",
                "crystalline", "cunning", "curious", "curled", "cyclopean",
                "dabbling", "dangerous", "dank", "dark", "dead", "dear", "decent",
                "decisive", "declining", "deep", "defective", "defended", "defensive",
                "deferent", "deified", "delightful", "dented", "depressed",
                "destined", "deteriorated", "deviant", "devious", "diamond",
                "dignified", "dim", "diminished", "dimpled", "dipped", "disemboweled",
                "disgusting", "dishonest", "disloyal", "dismal", "dispersed",
                "distant", "distinct", "distracting", "divine", "domestic",
                "dominant", "doomed", "dour", "doused", "drab", "dreadful", "dreamy",
                "drenched", "droopy", "dull", "dutiful", "dwindling", "early",
                "earthen", "east", "ecru", "eerie", "elder", "elevated",
                "emancipated", "embraced", "emerald", "imperial", "empty",
                "enchanted", "enjoyable", "entangled", "entrancing", "epidemic",
                "equal", "equivalent", "erased", "escorted", "esteemed", "eternal",
                "euphoric", "evaporated", "even", "everlasting", "everseeing", "evil",
                "eviscerated", "exalted", "excavated", "fabulous", "factional",
                "faded", "failed", "faint", "fair", "fair", "faithful", "false",
                "famous", "familial", "fancy", "fat", "fatal", "fated", "fed", "fell",
                "fenced", "feral", "ferocious", "fetid", "feverish", "fierce",
                "fiery", "first", "flaxen", "flayed", "flecked", "fleshy",
                "flickering", "flighty", "flimsy", "flowery", "foggy", "folded",
                "fondled", "foolish", "fortuitous", "fortunate", "fragile",
                "fragrant", "free", "fresh", "friendly", "frightful", "frigid",
                "frilly", "frosty", "frothy", "fruity", "fuchsia", "full", "furious",
                "future", "garish", "gaunt", "geared", "gilded", "girdled", "girlish",
                "glacial", "glad", "gleeful", "glittery", "gloomy", "glorious",
                "gloved", "glowing", "glum", "gnarled", "godly", "god", "golden",
                "goldenrod", "good", "gory", "grand", "granite", "grasping", "gray",
                "great", "greater", "greatest", "green", "grieving", "grim",
                "gristly", "grizzly", "grooved", "gross", "guilty", "habitual",
                "hairy", "hale", "handy", "hardy", "harmonious", "harsh", "hateful",
                "hazy", "healing", "hot", "heavenly", "heavy", "heliotrope",
                "hellish", "helmed", "helpful", "hermitic", "heroic", "hideous",
                "high", "hoary", "held", "hollow", "holy", "homely", "honest",
                "honorable", "hopeful", "humble", "humid", "humorous", "hungry",
                "icy", "idle", "ignited", "ignoble", "ignorant", "ill", "immoral",
                "immortal", "impervious", "imprisoned", "impure", "incidental",
                "incinerated", "inconsiderate", "inconvenient", "indigo",
                "infallible", "infamous", "infected", "inferior", "infinite",
                "influential", "inky", "innocent", "insensitive", "insightful",
                "intense", "intricate", "invisible", "ivory", "jade", "jaundiced",
                "bejeweled", "joyous", "just", "kindled", "kind", "laborious",
                "labyrinthine", "lacy", "laconic", "lamented", "languishing", "lardy",
                "large", "larval", "last", "late", "lauded", "lavender", "lazy",
                "leafy", "leaky", "lean", "least", "legendary", "lessened", "lesser",
                "living", "light", "limp", "lined", "little", "livid", "lone",
                "lonely", "lonesome", "long", "lost", "lovely", "low", "loyal",
                "lucid", "lucky", "lurid", "lush", "lustful", "lustrous", "luxurious",
                "lyrical", "magical", "mahogany", "malicious", "malign", "maligned",
                "malignant", "malodorous", "mangy", "maroon", "massive", "matched",
                "matched", "mauve", "mean", "mean", "meandering", "mechanical",
                "mellow", "merged", "messianic", "mighty", "mindful", "mint", "mired",
                "mirthful", "misty", "modest", "moist", "molten", "momentous",
                "monstrous", "moral", "morose", "mortal", "mortified", "most",
                "mountainous", "mournful", "mousy", "mucous", "muddled", "muddy",
                "murky", "muscular", "musical", "musty", "mute", "mysterious",
                "mythical", "named", "narrow", "nasty", "national", "natural",
                "naughty", "negative", "neutral", "new", "noble", "noiseless",
                "north", "notched", "nourishing", "null", "oaken", "obeisant",
                "obscene", "obscure", "occult", "oceanic", "ochre", "odorous", "oily",
                "old", "olive", "ominous", "oracular", "ordered", "organized",
                "outrageous", "padded", "painful", "pale", "parched", "passionate",
                "past", "patterned", "peaceful", "perfect", "permanent", "perplexing",
                "persuasive", "pink", "plain", "plaited", "plated", "playful",
                "pleated", "poetic", "pointy", "poisoned", "polished", "ponderous",
                "portentous", "praised", "pregnant", "present", "prestigious", "prim",
                "prime", "primitive", "pristine", "problematic", "profane", "puce",
                "pulpy", "pungent", "pure", "purged", "purple", "putrid", "puzzling",
                "quick", "quiescent", "quiet", "radiant", "rainy", "rancorous",
                "random", "rank", "rapid", "rare", "raw", "reclusive", "red", "regal",
                "released", "relieved", "remarkable", "renowned", "reputed",
                "respectful", "responsible", "reticent", "revered", "revolting",
                "rhyming", "rhythmic", "riddled", "righteous", "ripe", "risky",
                "roasted", "robust", "romantic", "roomy", "rosy", "rough", "round",
                "rounded", "routed", "royal", "ruined", "rumored", "russet", "rustic",
                "ruthless", "sable", "sacrificial", "sad", "safe", "saffron",
                "sagging", "salty", "sandaled", "satiny", "saturnine", "savage",
                "scabrous", "scalded", "scaly", "scandalous", "scarce", "scarlet",
                "scholarly", "scintillating", "scorching", "scoured", "scraped",
                "scrubbed", "sculpted", "searing", "secretive", "sensitive",
                "sensual", "sepia", "severe", "shady", "shaken", "shameful", "short",
                "shriveled", "sick", "sienna", "silent", "silken", "silky", "silty",
                "silvery", "simple", "sinful", "singed", "single", "sunken",
                "sizzling", "skewered", "skinny", "slick", "slim", "slippery",
                "slitted", "sloppy", "slow", "sly", "small", "smeared", "smooth",
                "snarling", "soaked", "soapy", "socketed", "solitary", "somber",
                "sooty", "sorcerous", "sour", "south", "spattered", "special",
                "speckled", "speechless", "spicy", "spidery", "spiteful",
                "splattered", "split", "spongy", "spotted", "sprayed", "spread",
                "spry", "spurting", "square", "squashed", "squeezing", "stable",
                "stale", "static", "steamy", "stern", "sticky", "still", "stinky",
                "stirred", "stoked", "stormy", "strange", "strangled", "strapping",
                "strategic", "strong", "strifeful", "stunted", "stupid", "submerged",
                "subordinate", "subtle", "sugary", "suicidal", "sullen", "sunny",
                "superior", "sweet", "sweltering", "swift", "symmetric", "systemic",
                "taciturn", "tactical", "tainted", "tall", "tame", "tan", "tangled",
                "tapered", "tattooed", "taupe", "taut", "teal", "tempted",
                "tenacious", "tender", "tenebrous", "tepid", "terrible", "thin",
                "thrifty", "tight", "tiled", "tin", "tired", "torrid", "torturous",
                "touchy", "tragic", "trampled", "tressed", "triangular", "trifling",
                "trim", "trite", "trussed", "trustworthy", "true", "truthful",
                "tufted", "turquoise", "twinkling", "ugly", "ultimate", "umber",
                "umbral", "unbridled", "uncertain", "uncommon", "undignified",
                "ungodly", "unholy", "unkempt", "unnameable", "unremarkable",
                "unseen", "unspeakable", "unswerving", "untamed", "unthinkable",
                "untoward", "untrustworthy", "unwelcome", "useless", "vanished",
                "veiled", "velvety", "venerable", "vermilion", "vigorous", "vile",
                "violent", "violet", "virginal", "virtuous", "vulgar", "walled",
                "waning", "warm", "washed", "watchful", "wavy", "waxy", "wayward",
                "weak", "wealthy", "weathered", "west", "wet", "whimsical",
                "whirling", "whiskered", "white", "wicked", "wild", "willful",
                "wilted", "windy", "wispy", "withered", "wondrous", "wooden", "wordy",
                "worried", "worshipful", "worthless", "worthy", "wretched", "yawning",
                "yellow", "young", "youthful"]



  @nouns = ["abatement", "abbey", "abyss", "accident", "ace", "ache",
        "act", "action", "admiration", "admirer", "adoration", "adulation",
        "adventure", "affection", "affliction", "age", "air", "alchemy",
        "ale", "allegiance", "alliance", "ally", "amazement", "amber",
        "ambiguity", "amethyst", "amusement", "ancient", "angel", "anger",
        "anguish", "animal", "ankle", "anvil", "ape", "apex", "apogee",
        "appearance", "apple", "aquamarine", "arch", "arena", "arm", "armor",
        "armory", "arrow", "artifact", "artifice", "ash", "assault",
        "assembly", "attack", "attic", "aunt", "aura", "author", "authority",
        "autonomy", "autumn", "avalanche", "axe", "baby", "back", "bait",
        "baker", "balance", "baldness", "ball", "band", "band", "bandit",
        "bane", "bank", "banner", "bar", "barb", "barbarian", "barbarity",
        "barricade", "basement", "basis", "basin", "bastion", "bath",
        "battle", "beach", "beak", "bean", "bear", "beard", "beast", "beauty",
        "bed", "bee", "beer", "beetle", "beguiler", "belch", "bell", "belly",
        "belt", "bend", "berry", "bewilderment", "bile", "bin", "bird",
        "bite", "bitterness", "blackness", "blade", "blame", "blanket",
        "blaze", "blight", "blindness", "blister", "blizzard", "bloat",
        "block", "blockade", "blood", "bloodiness", "blossom", "blot",
        "blotch", "blueness", "blush", "boar", "board", "boat", "bodice",
        "body", "bog", "boil", "boldness", "bolt", "bone", "book", "boot",
        "boredom", "bottle", "bottom", "boulder", "bow", "bowel", "bowel",
        "bowl", "boy", "braid", "brain", "brand", "brass", "bravery",
        "breach", "bread", "breaker", "breakfast", "breath", "breeches",
        "breed", "brew", "bride", "bridge", "bridle", "brigand", "brightness",
        "brilliance", "brim", "bristle", "bronze", "brother", "brunch",
        "brush", "brute", "buck", "buckle", "bud", "bug", "bulb", "bulwark",
        "bunch", "bunion", "bunny", "burden", "burn", "burial", "bush",
        "bushel", "business", "bust", "buster", "butcher",
        "butter", "butterfly", "button", "buzzard", "cactus", "cad", "cage",
        "cake", "calamity", "call", "callus", "calm", "camp", "cancer",
        "candle", "candy", "canker", "canyon", "carnage", "carnality",
        "casket", "castle", "cat", "catch", "cathedral", "cave", "cavern",
        "cavity", "ceiling", "celebration", "cell", "certainty", "chain",
        "chamber", "champion", "chance", "channel", "chant", "chaos",
        "chapel", "charcoal", "charity", "charm", "chasm", "chastity",
        "cheese", "chestnut", "child", "chill", "chip", "chocolate", "chunk",
        "church", "cinder", "cinnamon", "circle", "circumstance", "citadel",
        "city", "clam", "clan", "clarity", "clash", "clasp", "claw",
        "clearing", "cleft", "climate", "climax", "clinch", "cloak", "clock",
        "clod", "cloister", "closet", "cloud", "clout", "club", "cluster",
        "clutch", "clutter", "coal", "coalition", "coast", "cobalt", "cobra",
        "coil", "coincidence", "coldness", "color", "column", "combat",
        "combination", "comedy", "comet", "communion", "compassion",
        "competition", "complexity", "confederacy", "confederation",
        "confidence", "confinement", "conflagration", "conflict", "confusion",
        "conjunction", "conjurer", "connection", "conqueror", "consideration",
        "construct", "container", "contempt", "contest", "continent",
        "contingency", "contingent", "control", "controller", "convenience",
        "convent", "cook", "cooperation", "copper", "corridor", "corruption",
        "cosmos", "cottage", "cotton", "council", "counsellor", "couple",
        "courage", "courtesy", "coven", "cover", "crab", "cradle", "craft",
        "crater", "craze", "craziness", "cream", "creation", "creature",
        "creed", "creek", "creep", "creepiness", "cremation", "crescent",
        "crest", "crevice", "crew", "critter", "cross", "crow", "crowd",
        "crown", "crucifixion", "cruelty", "crusher", "crux", "crypt",
        "crystal", "cudgel", "culmination", "cult", "cup", "curiosity",
        "curl", "curse", "cusp", "cut", "cyclone", "cyst", "dabbler",
        "dagger", "dale", "dance", "danger", "dankness", "darkness", "date",
        "date", "daub", "dawn", "day", "dead", "dearth", "death", "decay",
        "deceiver", "decency", "decision", "decline", "deep", "deer",
        "defect", "defender", "defense", "deference", "deification", "deity",
        "delight", "dell", "demon", "den", "denomination", "dent",
        "depression", "depression", "depth", "desert", "desk", "despair",
        "dessert", "destiny", "destroyer", "destruction", "deterioration",
        "deviance", "devil", "devourer", "diamond", "dignity", "dike",
        "dimension", "diminishment", "dimple", "dinner", "dip", "direction",
        "dirge", "dirt", "disappearance", "discovery", "disemboweler",
        "disembowelment", "disgust", "dish", "disloyalty", "dispersal",
        "distance", "distinction", "distraction", "distraction", "distrust",
        "ditch", "diversion", "diversion", "doctrine", "dog", "domain",
        "domicile", "domination", "dominion", "donkey", "doom", "door", "dot",
        "dourness", "dragon", "drain", "drawl", "dread", "dream", "dreg",
        "dress", "dress", "drill", "drink", "drinker", "drip", "drool",
        "droopiness", "droplet", "drum", "dump", "dumpling", "dune", "dung",
        "dungeon", "dusk", "dust", "duty", "dweller", "dwelling", "dye",
        "eagle", "ear", "earth", "eater", "echo", "eel", "eerieness", "egg",
        "elbow", "elder", "elevation", "emancipation", "embrace", "emerald",
        "empire", "emptiness", "enchantment", "enchanter", "enjoyment",
        "entanglement", "entrails", "entrance", "entry", "epidemic",
        "equality", "equity", "equivalence", "erasure", "escort", "esteem",
        "euphoria", "evaporation", "evenness", "evil", "eviscerator",
        "evisceration", "exaltation", "excavation", "execution",
        "executioner", "exit", "extrication", "eye", "face", "faction",
        "failure", "faith", "faith", "fall", "falsehood", "fame", "family",
        "famine", "fanciness", "fang", "farm", "fat", "fate", "father",
        "fealty", "fear", "feast", "feed", "fell", "fellowship", "fence",
        "fern", "ferocity", "ferry", "fever", "field", "fiend", "fierceness",
        "fight", "figure", "filth", "fin", "finder", "finger", "fire", "fish",
        "fisher", "fissure", "fist", "flag", "flame", "flank", "flare",
        "flash", "flax", "flayer", "flea", "fleck", "flesh", "flicker",
        "flight", "flimsiness", "flood", "floor", "flower", "fluke", "flute",
        "fly", "flier", "focus", "fog", "fold", "fool", "foot", "ford",
        "forest", "forever", "fork", "fortification", "fortress", "fortune",
        "fortune", "fountain", "fragment", "fragrance", "frame", "freckle",
        "freedom", "frenzy", "friend", "fright", "frigidity", "frill", "frog",
        "frost", "froth", "fruit", "funeral", "fungus", "fur", "furnace",
        "fury", "future", "gale", "gall", "gallery", "galley", "gallows",
        "game", "gang", "garlic", "garnish", "gate", "gaze", "gear", "gem",
        "general", "genius", "gerbil", "ghost", "ghoul", "gift", "gill",
        "girder", "girdle", "girl", "glacier", "gladness", "glade", "gland",
        "glaze", "gleam", "glee", "glen", "glimmer", "glitter", "gloom",
        "glory", "gloss", "glove", "glow", "glumness", "glutton", "goad",
        "goal", "goat", "god", "gold", "goo", "good", "goose", "gore",
        "gorge", "grain", "granite", "grape", "grasp", "grass", "grave",
        "gravel", "grayness", "grease", "greatness", "greed", "greenness",
        "grief", "griffon", "grip", "gristle", "grizzle", "groove", "grotto",
        "group", "grove", "grower", "growl", "growth", "grub", "guard",
        "guild", "guile", "guilt", "guise", "gulf", "gulf", "gulf", "gully",
        "gut", "gutter", "habit", "hag", "hail", "hair", "hall", "hame",
        "hammer", "hammerer", "hand", "handle", "hardiness", "hare",
        "harmony", "harshness", "harvest", "harvester", "hatchet", "hate",
        "hatred", "haunt", "hawk", "hay", "haze", "head", "healer", "healing",
        "heart", "hearth", "heat", "heather", "heaven", "heaviness", "hedge",
        "hegemon", "hell", "helm", "help", "hermit", "hero", "hex", "hide",
        "hill", "hip", "hog", "hold", "hole", "hollow", "holiness", "homage",
        "home", "honesty", "honey", "honor", "hood", "hoof", "hop", "hopper",
        "hope", "horn", "horror", "horse", "hound", "hour", "house", "hovel",
        "howl", "hug", "humility", "humidity", "humor", "hunger", "hurricane",
        "hut", "ice", "idleness", "idol", "ignition", "ignorance", "illness",
        "image", "immorality", "immortal", "immortality", "imprisonment",
        "impunity", "impurity", "incense", "inch", "incident", "incineration",
        "inconvenience", "indignation", "infamy", "infection", "inferno",
        "influence", "ink", "inn", "innocence", "insanity", "insect",
        "insight", "intensity", "intricacy", "iron", "island", "itch",
        "ivory", "ivy", "jack", "jackal", "jade", "jail", "jailer",
        "jaundice", "jaw", "jester", "jewel", "joke", "joy", "judge",
        "juggler", "juice", "jungle", "justice", "keeper", "keg", "key",
        "killer", "kin", "kindling", "kindness", "king", "kingdom", "kiss",
        "knife", "knight", "knot", "labor", "labyrinth", "lace", "lake",
        "lamb", "lamentation", "lance", "lancer", "land", "language",
        "lantern", "lard", "lark", "larva", "lash", "law", "laziness",
        "leader", "leaf", "league", "leak", "leech", "legend", "lemon",
        "lens", "leopard", "leper", "leprosy", "lesion", "lesson", "letter",
        "liberation", "liberty", "library", "lie", "life", "light",
        "lightning", "lilac", "limb", "lime", "line", "lion", "lip", "lizard",
        "loaf", "lobster", "lock", "lock", "length", "loot", "lord", "louse",
        "love", "lover", "lowness", "loyalty", "lucidity", "luck", "lull",
        "lunch", "lung", "lure", "lust", "luster", "lute", "luxury", "lyric",
        "machine", "maggot", "magic", "magician", "malice", "malodor", "man",
        "mange", "manor", "mansion", "marble", "mark", "market", "marsh",
        "martyr", "master", "mastery", "match", "match", "maw", "maze",
        "mead", "meadow", "meal", "meal", "meanness", "meanness", "meat",
        "mechanism", "medicine", "meditation", "meeting", "memory", "menace",
        "merchant", "mesh", "mess", "messiah", "metal", "meteor", "midnight",
        "might", "mile", "mind", "mine", "minion", "mire", "mirror", "mirth",
        "misery", "mist", "mite", "mob", "modesty", "moistness", "mold",
        "mole", "moment", "monastery", "monger", "mongrel", "monk", "monkey",
        "monster", "moon", "mop", "moral", "morality", "morass", "morning",
        "morsel", "mortal", "mortality", "mortification", "moss", "moth",
        "mother", "mountain", "mouse", "mouth", "muck", "mucus", "mud",
        "muffin", "mule", "murder", "murk", "muscle", "mush", "mushroom",
        "music", "mystery", "myth", "nadir", "nail", "name", "nation",
        "nature", "naughtiness", "negator", "nest", "net", "nettle",
        "neutrality", "newt", "night", "nightmare", "noble",
        "noose", "nose", "notch", "number",
        "nut", "oak", "oar", "oat", "obeisance", "oblivion", "obscenity",
        "obscurity", "obstacle", "ocean", "odor", "oil", "olive", "omen",
        "one", "onion", "onslaught", "ooze", "oracle", "orange", "orb",
        "order", "order", "organ", "organization", "outrage", "owl", "owner",
        "ownership", "ox", "pack", "pad", "paddle", "page", "pain", "paint",
        "palace", "paleness", "palisade", "palm", "panther", "pantomime",
        "pants", "paper", "parity", "partner", "pass", "passage", "passion",
        "past", "pastime", "path", "pattern", "peace", "peach", "peak",
        "pear", "pearl", "pebble", "peek", "pelt", "pepper", "perfection",
        "perishment", "periwinkle", "permanency", "persuasion", "persuader",
        "pet", "petal", "phantom", "phlegm", "phrase", "pick", "pig",
        "pillar", "pimple", "pine", "pinnacle", "pit", "pitch", "plague",
        "plain", "plait", "plan", "plane", "planet", "plank", "plant",
        "planter", "plate", "play", "play", "pleat", "plot", "plum", "plunge",
        "pocket", "poem", "poet", "poetry", "point", "poison", "poker",
        "polish", "pool", "portal", "portent", "post", "pot", "power",
        "practice", "prairie", "praise", "prank", "pregnancy", "present",
        "prestige", "price", "pride", "priest", "prince", "princess",
        "principle", "prison", "problem", "profanity", "proliferation",
        "prophecy", "prophet", "prowler", "puke", "pulley", "pulp", "pumpkin",
        "punch", "pungency", "puppet", "purity", "purge", "pus",
        "putrescence", "puzzle", "quake", "quandary", "queen", "quest",
        "quickness", "quiescence", "quietness", "quill", "rabbit", "rabble",
        "race", "race", "rack", "radiance", "rag", "rage", "rain", "ram",
        "rampage", "rampart", "rancor", "rapidity", "raptor", "rasp", "rat",
        "raunch", "ravager", "raven", "rawness", "ray", "razor", "realm",
        "recluse", "recreation", "redness", "reign", "rein", "release",
        "relic", "relief", "renown", "reputation", "requirement", "respect",
        "responsibility", "reticence", "reverence", "reward", "rhyme",
        "rhythm", "riddle", "rider", "rift", "right", "righteousness", "rim",
        "ring", "rip", "ripeness", "ripper", "risk", "rite", "river", "road",
        "roar", "robustness", "rock", "rogue", "romance", "roof", "room",
        "root", "rooter", "rope", "rose", "rot", "roughness", "rout", "ruin",
        "ruler", "rumor", "rust", "ruthlessness", "sabre", "sack",
        "sacrifice", "sadness", "safety", "saffron", "saint", "salt",
        "salute", "salve", "sanctuary", "sanctum", "sand", "sandal", "sap",
        "satin", "saturninity", "savage", "savagery", "savant", "savior",
        "scab", "scale", "scandal", "scar", "scenario", "scholar", "scoop",
        "scorn", "scorpion", "scourge", "scrap", "scrape", "scratch",
        "scream", "scribe", "scuffle", "sculpture", "scum", "sea", "seal",
        "seal", "seam", "search", "season", "secret", "sect", "seduction",
        "seducer", "seed", "seer", "seizure", "sense", "serpent", "servant",
        "sever", "severity", "sewer", "shack", "shade", "shadow", "shaft",
        "shame", "shank", "shark", "sheen", "shell", "shelter", "shield",
        "shin", "shingle", "ship", "shock", "shore", "shove", "shovel",
        "show", "shower", "shred", "shriek", "shrine", "sick", "sickness",
        "side", "siege", "silence", "silk", "silkiness", "silt", "silver",
        "simplicity", "sin", "sinew", "song", "sister", "skewer", "skin",
        "skirt", "skull", "skunk", "sky", "slaughter", "slave", "slayer",
        "sleeve", "slime", "sling", "slit", "sliver", "slop", "sloth",
        "sludge", "slug", "smear", "smile", "smith", "smoke", "smoothness",
        "snack", "snail", "snake", "snarl", "sneer", "snot", "soap",
        "society", "socket", "soil", "soldier", "soot", "sorcerer", "sorcery",
        "sorrow", "soul", "sound", "sourness", "spark", "sparkle", "spasm",
        "spawn", "speech", "speaker", "spear", "speck", "speechlessness",
        "spell", "spice", "spider", "spike", "spine", "spiral", "spire",
        "spirit", "spit", "spite", "spittle", "splash", "spoils", "sponge",
        "spoon", "sport", "spot", "spray", "spring", "spring", "spurn",
        "spurt", "spy", "square", "squid", "stability", "staff", "stake",
        "stalker", "stance", "standard", "star", "starvation", "stasis",
        "steam", "steed", "steel", "stench", "steppe", "stick", "stigma",
        "stockade", "stoker", "stone", "stop", "storm", "strangeness",
        "stranger", "strangulation", "strap", "strategy", "straw", "stray",
        "stream", "strength", "strife", "strike", "string", "stroke", "stump",
        "stunt", "style", "subordinate", "subtlety", "sucker", "suffering",
        "sugar", "suicide", "suitor", "summit", "sun", "supper", "surprise",
        "swallow", "swamp", "sweat", "sweetness", "swine", "sword",
        "symmetry", "syrup", "system", "tactic", "tail", "taker", "talon",
        "tangle", "tar", "target", "tarnish", "tattoo", "tax", "teacher",
        "tear", "tempest", "temple", "temple", "temptation", "tenacity",
        "tenderness", "tentacle", "terror", "test", "theater", "thief",
        "thimble", "thirst", "thorn", "thrall", "threat", "thrift", "throat",
        "throne", "thrower", "thunder", "tick", "tick", "tightness", "tile",
        "time", "tin", "tip", "tiredness", "toad", "toast", "toe", "tomb",
        "tome", "tone", "tongs", "tongue", "tool", "tooth", "top", "torch",
        "torment", "tornado", "torture", "touch", "tour", "tournament",
        "tower", "town", "trade", "tragedy", "trail", "trammel", "trance",
        "trap", "trash", "treasure", "treat", "treaty", "tree", "trench",
        "tress", "trial", "triangle", "tribe", "tribute", "trick", "trickery",
        "trifle", "trim", "trooper", "trouble", "trough", "trumpet", "truss",
        "trust", "truth", "tub", "tube", "tuft", "tulip", "tummy", "tumor",
        "tundra", "tunnel", "turmoil", "turquoise", "tusk", "twig",
        "twilight", "twine", "twinkle", "twist", "typhoon", "ugliness",
        "ulcer", "umbra", "uncertainty", "uncle", "unholiness", "union",
        "universe", "urge", "urn", "utterance", "vale", "valley", "vandal",
        "vanishment", "vegetable", "vegetation", "veil", "velvet",
        "veneration", "venom", "vermin", "verse", "vessel", "vestibule",
        "vice", "victim", "vigor", "vileness", "village", "vine", "violator",
        "violence", "viper", "virgin", "virginity", "virtue", "vise",
        "vision", "visionary", "voice", "void", "volcano", "vomit",
        "vulgarity", "vulture", "wad", "wail", "walk", "wall", "wanderer",
        "wane", "war", "ward", "warmth", "warning", "warrior", "wart", "wasp",
        "waste", "watch", "watchfulness", "water", "wave", "waviness", "wax",
        "way", "weakness", "wealth", "weasel", "weather", "weathering",
        "weaver", "web", "weed", "weevil", "weight", "weird", "wheat",
        "wheel", "whim", "whip", "whisker", "whisky", "whisper", "whiteness",
        "wickedness", "wildness", "will", "wilt", "wind", "wine", "wing",
        "winnower", "winter", "wire", "wish", "wisp", "witch", "woman",
        "wonder", "wood", "word", "work", "worker", "world", "worm", "worry",
        "worship", "worshipper", "worth", "wrack", "wraith", "wrath",
        "wreath", "wretch", "yarn", "yawn", "year", "yearling", "yell",
        "yellowness", "yore", "youth", "zeal", "zealot", "zenith", "zephyr"]
