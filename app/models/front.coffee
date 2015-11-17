class SteadingOMatic.Models.Front extends SteadingOMatic.Models.Base

  url: -> if @get('_id') then "/api/steadings/#{@get('_id')}" else "/api/steadings"

  initialize: (attributes, options = {}) ->
    options.type ?= 'adventure'
    super(attributes, options)
    unless attributes._id?
      baseAttributes = switch options.type
        when 'adventure' then @defaultsForAdventure()
        when 'campaign' then @defaultsForCampaign()
      baseAttributes.description = @randomDescription(options.type)
      baseAttributes.name = @randomName()
      @set(baseAttributes)
    @set('enums', SteadingOMatic.Models.Front.enums)



  #
  # sets defaults for a new village
  #
  defaultsForAdventure: ->
    size: 'Village'
    prosperity: 'Poor'
    population: 'Steady'
    defenses: 'Militia'
    tags:
      tag: 'Resource', details: ''
      tag: 'Oath', details: ''

  #
  # sets defaults for a new town
  #
  defaultsForCampaign: ->
    size: 'Town'
    prosperity: 'Moderate'
    population: 'Steady'
    defenses: 'Watch'
    tags:
      tag: 'Trade', details: ''



  #
  # selects a random name
  #
  randomName: ->
    _.sample( SteadingOMatic.Models.Front.namesList )

  randomDescription: (type) ->
    "A randomly generated  #{type}"




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
    tags: [
      {
        value:0,
        key:"Safe",
        description:"Outside trouble doesn't come here until the players bring it. Idyllic and often hidden, if the steading would lose or degrade another beneficial tag get rid of safe instead."
      },
      {
        value:0,
        key:"Religion",
        description:"The listed deity is revered here."
      },
      {
        value:0,
        key:"Exotic",
        description:"There are goods and services available here that aren't available anywhere else nearby. List them."
      },
      {
        value:0,
        key:"Resource",
        description:"The steading has easy access to the listed resource (e.g., a spice, a type of ore, fish, grapes). That resource is significantly cheaper."
      },
      {
        value:0,
        key:"Need",
        description:"The steading has an acute or ongoing need for the listed resource. That resource sells for considerably more."
      },
      {
        value:0,
        key:"Oath",
        description:"The steading has sworn oaths to the listed steadings. These oaths are generally of fealty or support, but may be more specific."
      },
      {
        value:0,
        key:"Trade",
        description:"The steading regularly trades with the listed steadings."
      },
      {
        value:0,
        key:"Market",
        description:"Everyone comes here to trade. On any given day the available items may be far beyond their prosperity. +1 to supply."
      },
      {
        value:0,
        key:"Enmity",
        description:"The steading holds a grudge against the listed steadings."
      },
      {
        value:0,
        key:"History",
        description:"Something important once happened here, choose one and detail or make up your own: battle, miracle, myth, romance, tragedy."
      },
      {
        value:0,
        key:"Arcane",
        description:"Someone in town can cast arcane spells for a price. This tends to draw more arcane casters, +1 to recruit when you put out word you're looking for an adept."
      },
      {
        value:0,
        key:"Divine",
        description:"There is a major religious presence, maybe a cathedral or monastery. They can heal and maybe even raise the dead for a donation or resolution of a quest. Take +1 to recruit priests here."
      },
      {
        value:0,
        key:"Guild",
        description:"The listed type of guild has a major presence (and usually a fair amount of influence). If the guild is closely associated with a type of hireling, +1 to recruit that type of hireling."
      },
      {
        value:0,
        key:"Personage",
        description:"There's a notable person who makes their home here. Give them a name and a short note on why they're notable."
      },
      {
        value:0,
        key:"Dwarven",
        description:"The steading is significantly or entirely dwarves. Dwarven goods are more common and less expensive than they typically are."
      },
      {
        value:0,
        key:"Elven",
        description:"The steading is significantly or entirely elves. Elven goods are more common and less expensive than they typically are."
      },
      {
        value:0,
        key:"Craft",
        description:"The steading is known for excellence in the listed craft. Items of their chosen craft are more readily available here or of higher quality than found elsewhere."
      },
      {
        value:0,
        key:"Lawless",
        description:"Crime is rampant; authority is weak."
      },
      {
        value:0,
        key:"Blight",
        description:"The steading has a recurring problem, usually a type of monster."
      },
      {
        value:0,
        key:"Power",
        description:"The steading holds sway of some type. Typically political, divine, or arcane."
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