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
    description: @randomDescription(subtype)
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



  randomDescription: (type) ->
    "A randomly generated  #{type}"


  @patterns = [
    "the <plural_noun> of the <general_adjective> <noun>"
    "the <plural_noun>"
    "the <general_adjective> <plural_noun>"
    "<start_noun> of the <noun>"
    "<prefix>-<start_noun> of the <plural_noun>"
    "<prefix>|<start_noun>"
    "<start_noun> of the <plural_noun>"
    "<plural_noun> of the <noun>"
    "<adjective>|<start_noun>"
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
