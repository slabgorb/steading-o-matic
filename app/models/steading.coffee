class SteadingOMatic.Models.Steading extends SteadingOMatic.Models.Base

  className: 'Steading'
  url: -> if @get('_id') then "/api/steadings/#{@get('_id')}" else "/api/steadings"

  initialize: (attributes, options = {}) ->
    options.type ?= 'village'
    @type = options.type
    @set('enums', @constructor.enums)
    super(attributes, options)

  hasTag: (tagName) ->
    _.find @get('tags'), (tag) ->
      tag.tag.toLowerCase() == tagName.toLowerCase()

  randomize: ->
    promise = $.Deferred()
    @randomSteadings(5).done =>
      baseAttributes = switch @type
        when 'village' then @defaultsForVillage()
        when 'town' then @defaultsForTown()
        when 'city' then @defaultsForCity()
        when 'keep' then @defaultsForKeep()
      baseAttributes.icon = @randomIcon()
      baseAttributes.colors = @randomColorSet()
      baseAttributes.description = @randomDescription(@type)
      baseAttributes.name = @randomName()
      @set(baseAttributes)
      @save().done =>
        @fetch().done =>
          promise.resolve(@)
    promise

  randomSteadings: (count = 1) ->
    $.ajax
      url: "/api/random/steading/#{count}"
      method: 'GET'
      success: (resp) =>
        @randomSteadingList = _.map resp, (steadingData) -> new SteadingOMatic.Models.Steading(steadingData) or []

  randomSteadingName:(count = 1) -> _.map((_.sample @randomSteadingList, count), (s) -> s.get('name')).join(', ')

  #
  # sets defaults for a new village
  #
  defaultsForVillage:  ->
    size: 'Village'
    prosperity: 'Poor'
    population: 'Steady'
    defenses: 'Militia'
    tags:
      tag: 'Resource', details: ''
      tag: 'Oath', details: @randomSteadingName()

  #
  # sets defaults for a new town
  #
  defaultsForTown:  ->
    size: 'Town'
    prosperity: 'Moderate'
    population: 'Steady'
    defenses: 'Watch'
    tags:
      tag: 'Trade', details: @randomSteadingName(_.random(1,5))

  #
  # sets defaults for a new keep
  #
  defaultsForKeep:  ->
    size: 'Keep'
    prosperity: 'Poor'
    population: 'Shrinking'
    defenses: 'Guard'
    tags:
      tag: 'Trade', details: @randomSteadingName(_.random(1,5))
      tag: 'Oath', details: @randomSteadingName()

  #
  # sets defaults for a new city
  #
  defaultsForCity:   ->
    size: 'City'
    prosperity: 'Moderate'
    population: 'Steady'
    defenses: 'Guard'
    tags:
      tag: 'Oath', details: @randomSteadingName()
      tag: 'Guild', details: ''
      tag: 'Market', details: ''
      tag: 'Trade', details: @randomSteadingName(_.random(1,5))

  randomDescription: (type) ->
    "A randomly generated  #{type}"

  @patterns = [
    "<prefix>|<suffix>"
    "<prefix> <noun>|<suffix>"
    "<short_adjective>|<short_noun>|<suffix>"
    "<prefix> <short_adjective>|<short_noun>"
    "<noun>|<suffix>"
    "<noun>|<suffix>"
    "<adjective>|<suffix>"
    "<adjective>|<suffix>"
    "<short_adjective>|<suffix>"
    "<short_adjective>|<suffix>"
    "<adjective> <end_noun>"
    "<noun> <end_noun>"
    "<adjective> <end_noun>"
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
