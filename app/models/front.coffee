class SteadingOMatic.Models.Front extends SteadingOMatic.Models.Base

  url: -> if @get('_id') then "/api/fronts/#{@get('_id')}" else "/api/fronts"

  initialize: (attributes, options = {}) ->
    options.type ?= 'adventure'
    super(attributes, options)
    unless attributes._id?
      baseAttributes = switch options.type
        when 'adventure' then @defaultsForAdventure()
        when 'campaign' then @defaultsForCampaign()
      baseAttributes.description = @randomDescription(options.type)
      baseAttributes.dangers = _.uniq(_.times(_.random(1,3), => @randomDanger(options.type)))
      baseAttributes.portents = _.uniq(_.times(_.random(3,5), => @randomPortent(baseAttributes.dangers)))
      baseAttributes.stakes = _.uniq(_.times(_.random(2,4), => @randomStake(baseAttributes.dangers)))
      baseAttributes.cast = _.uniq(_.times(_.random(1,5), => @randomName()))
      baseAttributes.name = @randomName()
      @set(baseAttributes)
    @set('enums', SteadingOMatic.Models.Front.enums)

  #
  # sets defaults for a new adventure front
  #
  defaultsForAdventure: ->
    type: 'Adventure'

  #
  # sets defaults for a new campaign front
  #
  defaultsForCampaign: ->
    type: 'Campaign'

  randomDanger: ->
    type = _.sample(_.keys(SteadingOMatic.Models.Front.enums.dangers.types))
    subtype = _.sample(_.keys(SteadingOMatic.Models.Front.enums.dangers.types[type].subtypes))
    subtypeData = SteadingOMatic.Models.Front.enums.dangers.types[type].subtypes[subtype]
    type: type
    subtype: subtype
    name: @randomName(subtypeData.patterns, subtypeData.nouns, subtypeData.start_nouns, subtypeData.adjectives,  subtypeData.prefixes)
    impulse: subtypeData.impulse
    description: ''
    doom: @randomDoom(type)
    moves: subtypeData.moves
    icon: @randomIcon()
    colors: @randomColorSet()

  randomImpulse: (type)-> _.sample(SteadingOMatic.Models.Front.enums.dangers.types[type])

  randomDoom: (type) -> _.sample(SteadingOMatic.Models.Front.enums.dangers.types[type].dooms)

  randomPortent: (dangers) ->
    danger = _.sample(dangers)
    _.sample(SteadingOMatic.Models.Front.enums.dangers.types[danger.type].portents)

  randomStake: (dangers) ->
    danger = _.sample(dangers)
    _.sample(SteadingOMatic.Models.Front.enums.dangers.types[danger.type].stakes)(danger)

  #
  # selects a random name
  #
  randomName: (patterns, nouns, start_nouns, adjectives,  prefixes) ->

    patterns ?= SteadingOMatic.Models.Front.patterns
    nouns ?= SteadingOMatic.Models.Front.nouns
    start_nouns ?= nouns
    adjectives ?= SteadingOMatic.Models.Front.adjectives
    prefixes ?= SteadingOMatic.Models.Front.prefixes
    pattern = _.sample(patterns)

    tokens = _.map pattern.split(/\s|\-/), (token) ->
      switch token
        when "<plural_noun>" then _.pluralize(_.sample(nouns))
        when "<noun>" then _.sample(nouns)
        when "<start_noun>" then _.sample(start_nouns)
        when "<adjective>" then _.sample(adjectives)
        when "<general_noun>" then _.sample(SteadingOMatic.Models.Front.nouns)
        when "<general_adjective>" then _.sample(SteadingOMatic.Models.Front.adjectives)
        when "<plural_general_noun>" then _.pluralize(_.sample(SteadingOMatic.Models.Front.nouns))
        else token
    _.titleize tokens.join(' ')

  randomDescription: (type) ->
    "A randomly generated  #{type}"

  addAdjective: ->
    _.sample(SteadingOMatic.Models.Front.adjectives)

  addNoun: ->
    _.sample(SteadingOMatic.Models.Front.nouns)

  @patterns = [
    "the <plural_noun> of the <general_adjective> <noun>"
    "the <plural_noun>"
    "the <general_adjective> <plural_noun>"
    "<start_noun> of the <noun>"
    "<prefix>-<start_noun> of the <plural_noun>"
    "<start_noun> of the <plural_noun>"
    "<plural_noun> of the <noun>"
  ]
  @enums =
    dangers:
      types:
        'Ambitious Organizations':
          subtypes:
            'Misguided Good':
              impulse: 'to do what is “right” no matter the cost'
            'Thieves Guild':
              impulse: 'to take by subterfuge'
              start_nouns: [
                'syndicate', 'association', 'cartel', 'gang', 'mob',
                'organization', 'ring', 'union', 'board', 'bunch',
                'chamber', 'committee', 'company', 'council', 'crew',
                'group', 'outfit', 'partnership',
              ]
              nouns: [
                'blade', 'fence', 'pilferers', 'peculation',
                'misappropriation', 'withdrawal',
                'pinchers', 'theif', 'poach', 'poacher', 'purloiner',
                'pirate', 'burglar', 'larceny'
              ]
              adjectives: [
                'petty', 'involuntary', 'quick', 'hidden', 'peculiar',
                'old', 'new', 'larcenous', 'deft', 'adroit', 'apt',
                'neat', 'prompt', 'dexterous', 'criminal'
              ]
              patterns: [
                'the <start_noun> of <adjective> <noun>'
                '<adjective> <start_noun> of <noun>'
                '<adjective> <start_noun>'
                '<plural_noun> <start_noun>'
                '<plural_noun> <adjective> <start_noun>'
              ]

            'Cult':
              impulse: 'to infest from within'
              adjectives: [
                'serene', 'calm', 'frenzied'
              ]
              start_nouns: [
                'band', 'church', 'clan', 'clique', 'denomination',
                'faith', 'religion', 'sect', 'body', 'creed',
                'faction', 'following', 'party', 'persuasion',
                'school', 'chapel', 'mosque', 'parish', 'sanctuary',
                'shrine', 'synagogue', 'temple', 'abbey', 'basilica',
                'bethel', 'cathedral', 'chancel', 'chantry', 'fold',
                'minster', 'mission', 'oratory', 'tabernacle', 'shrine'
              ]
              adjectives: [
                'divine', 'hallowed', 'humble', 'pure', 'revered',
                'righteous', 'spiritual', 'sublime', 'believing',
                'clean', 'devotional', 'faithful', 'good', 'innocent',
                'moral', 'perfect', 'upright', 'angelic', 'blessed',
                'chaste', 'consecrated', 'dedicated', 'devoted',
                'devout', 'faultless', 'glorified', 'god-fearing',
                'godlike', 'godly', 'immaculate', 'just', 'messianic',
                'pietistic', 'pious', 'prayerful', 'reverent',
                'sacrosanct', 'sainted', 'saintlike', 'saintly',
                'sanctified', 'seraphic', 'spotless', 'uncorrupt',
                'undefiled', 'untainted', 'unworldly', 'venerable',
                'venerated', 'virtuous', 'righteous'
              ]

            'Religious Organization':
              impulse: 'to establish and follow doctrine'
              start_nouns: [
                'band', 'church', 'clan', 'clique', 'denomination',
                'faith', 'religion', 'sect', 'body', 'creed',
                'faction', 'following', 'party', 'persuasion',
                'school', 'chapel', 'mosque', 'parish', 'sanctuary',
                'shrine', 'synagogue', 'temple', 'abbey', 'basilica',
                'bethel', 'cathedral', 'chancel', 'chantry', 'fold',
                'minster', 'mission', 'oratory', 'tabernacle', 'shrine'
              ]
              adjectives: [
                'divine', 'hallowed', 'humble', 'pure', 'revered',
                'righteous', 'spiritual', 'sublime', 'believing',
                'clean', 'devotional', 'faithful', 'good', 'innocent',
                'moral', 'perfect', 'upright', 'angelic', 'blessed',
                'chaste', 'consecrated', 'dedicated', 'devoted',
                'devout', 'faultless', 'glorified', 'god-fearing',
                'godlike', 'godly', 'immaculate', 'just', 'messianic',
                'pietistic', 'pious', 'prayerful', 'reverent',
                'sacrosanct', 'sainted', 'saintlike', 'saintly',
                'sanctified', 'seraphic', 'spotless', 'uncorrupt',
                'undefiled', 'untainted', 'unworldly', 'venerable',
                'venerated', 'virtuous', 'righteous'
              ]

            'Corrupt Government':
              impulse: 'to maintain the status quo'
              start_nouns: [
                'kingdom', 'commonwealth', 'country', 'county',
                'crown', 'division', 'domain', 'dominion', 'dynasty',
                'empire', 'field', 'lands', 'monarchy', 'nation',
                'possessions', 'principality', 'province', 'realm',
                'reign', 'rule', 'scepter', 'sovereignty', 'sphere',
                'state', 'suzerainty', 'sway', 'territory', 'throne',
                'tract'
              ]

            'Cabal':
              impulse: 'to absorb those in power, to grow'
              start_nouns: [
                'conspiracy', 'intrigue', 'scheme', 'assembly',
                'association', 'cartel', 'conglomerate', 'gang',
                'mob', 'organization', 'ring', 'union', 'board',
                'bunch', 'cabinet', 'chain', 'chamber', 'combine',
                'committee', 'company', 'council', 'crew', 'group',
                'outfit'
              ]
          moves: [
            'Attack someone by stealthy means (kidnapping, etc.)'
            'Attack someone directly (with a gang or single assailant)'
            'Absorb or buy out someone important (an ally, perhaps)'
            'Influence a powerful institution (change a law, manipulate doctrine)'
            'Establish a new rule (within the organization)'
            'Claim territory or resources'
            'Negotiate a deal'
            'Observe a potential foe in great detail'
          ]
          dooms: ['Tyranny', 'Usurpation', 'Impoverishment']
          portents: ['Refugees appear','Diplomacy breaks down']
          stakes: [
            (d) -> "Who will be the new leader of #{d.name}"
            (d) -> "What organization will rival #{d.name}?"
          ]

        'Planar Forces':
          subtypes:
            'God':
              impulse: 'to gather worshippers'
            'Demon Prince':
              impulse: 'to open the gates of Hell'
              start_nouns: [
                'emperor', 'star', 'monarch', 'sultan', 'baron',
                'caliph', 'khan', 'magnate', 'maharajah', 'majesty',
                'mogul', 'overlord', 'pasha', 'prince',
                'rajah', 'rex', 'shah', 'sovereign', 'tycoon',
                'imperator', 'king', 'overlord', 'potentate',
                'prince', 'ruler', 'sovereign', 'god', 'deity', 'patron'
              ]
              nouns: [
                'hell', 'deadland', 'afterworld', 'inferno',
                'nightmare', 'abyss', 'grave', 'limbo', 'underworld',
                'pit'
              ]
              patterns: [
                '<start_noun> of the <adjective> <noun>'
                '<prefix>-<start_noun> of the <plural_noun>'
                '<noun> <start_noun>'
                '<adjective> <start_noun> of the <noun>'
                '<adjective> <start_noun> of the <plural_noun>'
              ]
            'Elemental Lord':
              impulse: 'to tear down creation to its component parts'
              start_nouns: [
                'emperor', 'star', 'monarch', 'star', 'sultan',
                'baron', 'caliph', 'khan', 'magnate', 'maharajah',
                'majesty', 'mogul', 'overlord', 'pasha', 'potentate',
                'prince', 'rajah', 'rex', 'shah', 'sovereign',
                'tycoon', 'imperator', 'baron', 'count', 'duke',
                'earl', 'king', 'marquis', 'monarch', 'overlord',
                'potentate', 'prince', 'ruler', 'sovereign',
                'viscount'
              ]
              nouns: [
                'air', 'alchemy', 'breath','drowning', 'dust',
                'earth', 'enchantment', 'fire', 'flame', 'inferno',
                'magnetism', 'matter', 'power','stone', 'water',
                'wave', 'wind'
              ]
              patterns: [
                '<start_noun> of the <adjective> <noun>'
                '<prefix>-<start_noun> of the <plural_noun>'
              ]
            'Force of Chaos':
              impulse: 'to destroy all semblance of order'
            'Choir of Angels':
              impulse: 'to pass judgement'
            'Construct of Law':
              impulse: 'to eliminate perceived disorder'
          moves: [
            'Turn an organization (corrupt or infiltrate with influence)'
            'Give dreams of prophecy'
            'Lay a Curse on a foe'
            'Extract a promise in exchange for a boon'
            'Attack indirectly, through intermediaries'
            'Rarely, when the stars are right, attack directly'
          ]
          dooms: ['Tyranny', 'Destruction', 'Rampant Chaos']
          portents: ['Dimensional portals appear', 'A rift opens to another plane', 'The weather gets hotter and hotter','The weather gets colder and colder', 'Tornados appear randomly','Snakes everywhere','Frogs everywhere']
          stakes: [
            (d) -> "Who will close the rift that was opened by #{d.name}"
          ]

        'Arcane Enemies':
          subtypes:
            'Lord of the Undead':
              impulse: 'to seek true immortality'
              start_nouns: [
                'emperor', 'star', 'monarch', 'star', 'sultan',
                'baron', 'caliph', 'khan', 'magnate', 'maharajah',
                'majesty', 'mogul', 'overlord', 'pasha', 'potentate',
                'prince', 'rajah', 'rex', 'shah', 'sovereign',
                'tycoon', 'imperator', 'baron', 'count', 'duke',
                'earl', 'king', 'marquis', 'monarch', 'overlord',
                'potentate', 'prince', 'ruler', 'sovereign',
                'viscount'
              ]
              patterns: [
                '<start_noun> of the <adjective> <noun>'
                '<prefix>-<start_noun> of the <plural_noun>'
              ]

            'Power-mad Wizard':
              impulse: 'to seek magical power'
            'Sentient Artifact':
              impulse: 'to find a worthy wielder'
              start_nouns: [
                'sword', 'knife', 'blade', 'dagger', 'saber',
                'broadsword', 'claymore', 'cutlass', 'dirk', 'epee',
                'falchion', 'kris', 'rapier', 'sabre', 'scimitar',
                'glaive', 'orb', 'rod', 'wand', 'baton', 'scepter',
                'staff', 'baton', 'bowl', 'bow', 'necklace', 'ring',
                'brooch', 'chariot', 'saddle', 'horn', 'lyre', 'harp',
                'pipe', 'cup', 'goblet', 'chalice', 'cauldron',
                'throne'
              ]
              patterns: [
                '<start_noun> of the <noun>'
                '<adjective> <start_noun> of the <noun>'
                '<adjective> <start_noun>'
                '<prefix>-<adjective> <start_noun>'
                '<start_noun>, the <noun> of <noun>'
                '<noun> <start_noun>'
              ]

            'Ancient Curse':
              impulse: 'to ensnare'
            'Chosen One':
              impulse: 'to fulfill or resent their destiny'
            'Dragon':
              impulse: 'to hoard gold and jewels, to protect the clutch'
              start_noun: [
                'wyrm', 'dragon', 'snake', 'serpent', 'demon'
              ]
          moves: [
            'Foster rivalries with other, similar powers'
            'Expose someone to a Truth, wanted or otherwise'
            'Learn forbidden knowledge'
            'Cast a spell over time and space'
            'Attack a foe with magic, directly or otherwise'
            'Spy on someone with a scrying spell'
            'Recruit a follower or toady'
            'Tempt someone with promises'
            'Demand a sacrifice'
          ]
          dooms: ['Destruction', 'Pestilence']
          portents: ['Magical emanations', 'Mutant animals']
          stakes: [
            (d) -> "What will stop the plans for #{d.name}?"
          ]

        'Hordes':
          subtypes:
            'Wandering Barbarians':
              impulse: 'to grow strong, to drive their enemies before them'
              nouns: [
                'avalanche', 'affliction', 'attack', 'avalanche',
                'barbarity', 'band', 'beast', 'bitterness',
                'blackness', 'blight', 'blood', 'bone', 'brigand',
                'calamity', 'camp', 'carnage', 'champion', 'clan'
                'conflagration', 'conqueror', 'crusher', 'darkness',
                'despair', 'destroyer', 'disemboweler',
                'disembowlement', 'destruction', 'dragon', 'sune',
                'eagle', 'emptiness', 'epidemic', 'eviscerator',
                'executioner', 'fierceness', 'flayer', 'fortune',
                'freedom', 'frenzy', 'gang', 'hammer', 'harshness',
                'hate', 'hatred', 'hell', 'hunger', 'hurricane',
                'immortal', 'inferno', 'insanity', 'iron', 'justice',
                'killer', 'lash', 'leader', 'legend', 'minion', 'mob',
                'mortification', 'nation', 'pack', 'passion',
                'plague', 'proliferation', 'prophet', 'purity',
                'purge', 'rampage', 'ravager', 'rider', 'savage',
                'savagery', 'scum', 'shriek', 'society', 'soldier',
                'steppe', 'tempest', 'thirst', 'threat', 'torment',
                'tornado', 'tribe', 'tundra', 'typhoon', 'vandal',
                'vermin', 'violator', 'violence', 'volcano',
                'wanderer', 'warrior', 'wave', 'waste', 'wheel',
                'whip', 'world', 'zealot'
              ]
              patterns: [
                "the <plural_noun> of the <general_adjective> <noun>"
                "the <plural_noun>"
                "the <general_adjective> <plural_noun>"
                "<noun> of the <noun>"
                "<prefix>-<noun> of the <plural_noun>"
                "<noun> of the <plural_noun>"
                "<plural_noun> of the <noun>"
              ]
            'Humanoid Vermin':
              impulse: 'to breed, to multiply and consume'
              nouns: [
                'avalanche', 'affliction', 'attack', 'avalanche',
                'barbarity', 'band', 'beast', 'bitterness', 'butcher'
                'blackness', 'blight', 'blood', 'bone', 'brigand',
                'calamity', 'carnage', 'champion', 'creep', 'carnage'
                'conflagration', 'conqueror', 'crusher', 'darkness',
                'despair', 'destroyer', 'disemboweler', 'dungeon'
                'disembowlement', 'destruction', 'dragon', 'dune',
                'eagle', 'emptiness', 'epidemic', 'eviscerator',
                'executioner', 'fierceness', 'flayer', 'fortune',
                'frenzy', 'gang', 'hammer', 'harshness',
                'hate', 'hatred', 'hell', 'hunger', 'hurricane',
                'immortal', 'inferno', 'insanity', 'iron', 'justice',
                'killer', 'lash', 'leader', 'legend', 'minion', 'mob',
                'mortification', 'nation', 'pack', 'passion',
                'plague', 'proliferation', 'prophet', 'purity',
                'purge', 'rampage', 'ravager', 'rider', 'savage',
                'savagery', 'scum', 'shriek', 'society', 'soldier',
                'tempest', 'thirst', 'threat', 'torment',
                'tornado', 'tribe', 'typhoon', 'vandal',
                'vermin', 'violator', 'violence', 'volcano',
                'wanderer', 'warrior', 'wave', 'waste', 'wheel',
                'whip', 'world', 'zealot'
              ]
              patterns: [
                "the <plural_noun> of the <general_adjective> <noun>"
                "the <plural_noun>"
                "the <general_adjective> <plural_noun>"
                "<noun> of the <noun>"
                "<prefix>-<noun> of the <plural_noun>"
                "<noun> of the <plural_noun>"
                "the <noun>"
                "<plural_noun> of the <noun>"
              ]
            'Underground Dwellers':
              impulse: 'to defend the complex from outsiders'
              nouns: [
                'avalanche', 'affliction', 'attack', 'avalanche',
                'barbarity', 'band', 'beast', 'bitterness', 'butcher'
                'blackness', 'blight', 'blood', 'bone', 'brigand',
                'calamity', 'carnage', 'champion', 'creep', 'carnage'
                'conflagration', 'conqueror', 'crusher', 'darkness',
                'despair', 'destroyer', 'disemboweler', 'dungeon'
                'disembowlement', 'destruction', 'cave'
                'emptiness', 'epidemic', 'eviscerator',
                'executioner', 'fierceness', 'flayer', 'fortune',
                'frenzy', 'gang', 'hammer', 'harshness',
                'hate', 'hatred', 'hell', 'hunger', 'hurricane',
                'immortal', 'inferno', 'insanity', 'iron', 'justice',
                'killer', 'lash', 'leader', 'legend', 'minion', 'mob',
                'mortification', 'nation', 'pack', 'passion',
                'plague', 'proliferation', 'prophet', 'purity',
                'purge', 'rampage', 'ravager', 'rider', 'savage',
                'savagery', 'scum', 'shriek', 'society', 'soldier',
                'tempest', 'thirst', 'threat', 'torment',
                'tornado', 'tribe', 'typhoon', 'vandal',
                'vermin', 'violator', 'violence', 'volcano',
                'wanderer', 'warrior', 'wave', 'waste', 'wheel',
                'whip', 'world', 'zealot'
              ]
              patterns: [
                "the <plural_noun> of the <general_adjective> <noun>"
                "the <plural_noun>"
                "the <general_adjective> <plural_noun>"
                "<noun> of the <noun>"
                "<prefix>-<noun> of the <plural_noun>"
                "<noun> of the <plural_noun>"
                "the <noun>"
                "<plural_noun> of the <noun>"
              ]

            'Plague of the Undead':
              impulse: 'to spread'
              nouns: [
                'affliction', 'attack', 'avalanche', 'avalanche',
                'band', 'barbarity', 'beast', 'bitterness', 'blackness'
                'blight', 'blood', 'bone', 'brigand', 'butcher',
                'calamity', 'carnage', 'carnage', 'conflagration', 'conqueror'
                'creep', 'crusher', 'darkness', 'demon',
                'despair', 'destroyer', 'destruction', 'disemboweler'
                'disembowlement', 'doom', 'dragon', 'dungeon',
                'emptiness', 'epidemic', 'eviscerator',
                'executioner', 'fierceness', 'flayer', 'fortune',
                'frenzy', 'gang', 'hammer', 'harshness',
                'hate', 'hatred', 'hell', 'hunger', 'hurricane',
                'immortal', 'inferno', 'insanity', 'iron', 'justice',
                'killer', 'lash', 'leader', 'legend', 'minion', 'mob',
                'mortification', 'nation', 'pack', 'passion',
                'plague', 'proliferation',  'purge',
                'purity', 'rampage', 'ravager', 'rider', 'savage',
                'savagery', 'scum', 'shriek', 'society', 'soldier',
                'tempest', 'thirst', 'threat', 'torment',
                'tornado', 'tribe', 'typhoon', 'vandal',
                'vermin', 'violator', 'violence', 'volcano',
                'wanderer', 'warrior', 'waste', 'wave', 'wheel',
                'whip', 'world', 'zealot'
              ]
              patterns: [
                "the <plural_noun> of the <general_adjective> <noun>"
                "the <plural_noun>"
                "the <general_adjective> <plural_noun>"
                "<noun> of the <noun>"
                "<prefix><noun> of the <plural_noun>"
                "<noun> of the <plural_noun>"
                "the <noun>"
                "<plural_noun> of the <noun>"
              ]
          moves: [
            'Assault a bastion of civilization'
            'Embrace internal chaos'
            'Change direction suddenly'
            'Overwhelm a weaker force'
            'Perform a show of dominance'
            'Abandon an old home, find a new one'
            'Grow in size by breeding or conquest'
            'Appoint a champion'
            'Declare war and act upon that declaration without hesitation or deliberation'
          ]
          dooms: ['Destruction', 'Rampant Chaos']
          portents: ['Refugees appear', 'Scouts are sighted', 'The rumors of war']
          stakes: [
            (d) -> "Who will lead the battle against #{d.name}?"
            (d) -> "Is there a way to redirect #{d.name}?"
          ]

        'Cursed Places':
          subtypes:
            'Abandoned Tower':
              impulse: 'to draw in the weak-willed'
              nouns: [
                'abbey', 'apex', 'church', 'belfry', 'castle',
                'citadel', 'column', 'fort', 'fortification',
                'fortress', 'keep', 'lookout', 'mast', 'minaret',
                'monolith', 'obelisk', 'pillar', 'refuge', 'spire',
                'steeple', 'stronghold', 'turret'
              ]
              patterns: [
                "the <noun> of the <general_adjective> <general_noun>"
                "<noun> of <general_adjective> <general_noun>"
                "the <general_adjective> <noun>"
                "<noun> of the <general_noun>"
                "<prefix>-<noun> of the <general_noun>"
                "<general_adjective> <noun> of the <plural_noun>"
              ]
            'Unholy Ground':
              impulse: 'to spawn evil'
              nouns: [
                'catacomb', 'cemetery', 'charnel', 'charnel house', 'city'
                'churchyard', 'city of the dead', 'clump', 'coppice',
                'copse', 'crypt', 'garden', 'grave', 'graveyard',
                'grove', 'growth', 'jungle', 'meadow', 'mortuary',
                'necropolis', 'ossuary', 'pasture', 'polyandrium',
                'resting place', 'sepulcher', 'stand', 'steppe',
                'thicket', 'tomb', 'town', 'vault', 'village', 'weald', 'wood'
              ]
              adjectives: [
                'angry', 'atrocious', 'baneful', 'base', 'base',
                'beastly', 'blameful', 'calamitous', 'corrupt',
                'culpable', 'damnable', 'depraved', 'destructive',
                'disastrous', 'dishonest', 'evil', 'execrable',
                'flagitious', 'foul', 'godless', 'guilty', 'harmful',
                'hateful', 'heinous', 'hideous', 'immoral', 'impious',
                'iniquitous', 'injurious', 'irreligious',
                'irreverent', 'irreverential', 'loathsome', 'low',
                'maleficent', 'malevolent', 'malicious', 'malignant',
                'nefarious', 'obscene', 'offensive', 'pernicious',
                'poison', 'profane', 'rancorous', 'reprobate',
                'repugnant', 'repulsive', 'revolting', 'sinful',
                'spiteful', 'stinking', 'ugly', 'ungodly',
                'unhallowed', 'unpleasant', 'unpropitious',
                'unsanctified', 'vicious', 'vile', 'villainous',
                'wicked', 'wrathful', 'wrong',
              ]
              patterns: [
                "the <adjective> <noun> of the <general_adjective> <general_noun>"
                "<noun> of <general_adjective> <general_noun>"
                "the <adjective> <noun>"
                "<prefix><adjective> <noun>"
                "<adjective> <noun> of the <general_noun>"
                "<prefix><adjective> <noun> of the <general_noun>"
                "<general_adjective> <noun> of the <general_noun>"
              ]
            'Elemental Vortex':
              impulse: 'to grow, to tear apart reality'
              nouns: [
                'air', 'alchemy', 'breath', 'country', 'demesne',
                'domain', 'dominion', 'drowning', 'dust', 'earth',
                'enchantment', 'enclave', 'fire', 'flame', 'inferno',
                'magnetism', 'matter', 'power', 'realm', 'sphere',
                'stone', 'water', 'wave', 'wind'
              ]
              patterns: [
                "the <<general_adjective>> <noun> of the <general_adjective> <general_noun>"
                "<noun> of <general_adjective> <general_noun>"
                "the <general_adjective> <noun>"
                "<prefix><general_adjective> <noun>"
                "<adjective> <noun> of the <general_noun>"
                "<prefix><general_adjective> <noun> of the <general_noun>"
                "<general_adjective> <noun> of the <general_noun>"
              ]
            'Dark Portal':
              impulse: 'to disgorge demons'
              nouns: [
                'door', 'doorway', 'exit', 'fence', 'port', 'access',
                'conduit', 'egress', 'gateway', 'issue', 'lock',
                'opening', 'passage', 'portal', 'portcullis',
                'ingress', 'vent', 'turnstile', 'way', 'weir'
              ]
            'Shadowland':
              impulse: 'to corrupt or consume the living'
            'Place of Power':
              impulse: 'to be controlled or tamed'
          moves: [
            'Vomit forth a lesser monster'
            'Spread to an adjacent place'
            'Lure someone in'
            'Grow in intensity or depth'
            'Leave a lingering effect on an inhabitant or visitor'
            'Hide something from sight'
            'Offer power'
            'Dampen magic or increase its effects'
            'Confuse or obfuscate truth or direction'
            'Corrupt a natural law'
          ]
          dooms: ['Pestilence', 'Destruction', 'Rampant Chaos']
          portents: ['A gloom upon the land', 'Children disappear']
          stakes: [
            (d) -> "What will be sacrificed to stop the curse?"
            (d) -> "What will fulfill the curse?"
          ]

  @prefixes = ["after", "arch", "dozen", "ecto", "ever", "many",
             "necro", "neo", "never", "one", "over", "three", "two",
             "ultra", "un", "under"]

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
        "neutrality", "neutralization", "newt", "night", "nightmare", "noble",
        "noiselessness", "noose", "nose", "notch", "nourishment", "number",
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
