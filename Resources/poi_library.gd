extends Resource
class_name POI_Library

enum Shop_Type{
	DICE,
	SKILL,
	ITEM,
	CHARM,
	COMBO
}
enum Event_Type{
	BASIC,
	DISCARD, #This needs 11
	UPGRADE,
	FOUNTAIN,
	RIDDLE,
	WELL,
	ROLLOFF
}

var event_type_array = [Event_Type.ROLLOFF]#[Event_Type.BASIC,Event_Type.DISCARD,Event_Type.UPGRADE,Event_Type.FOUNTAIN,Event_Type.WELL,Event_Type.RIDDLE,Event_Type.ROLLOFF]

enum Event_Results {
	LOSSHPMINOR,
	LOSSHPMAJOR,
	STARTBATTLE,
	STARTTRAP,
	ADDHPMINOR,
	ADDHPMAJOR,
	ADDDICE,
	ADDITEM,
	NOTHING
}


var battle_poi:Dictionary = {
	"poi_code":0,
	"img_selector":"",
	"enemies":[],
	"reward":"gold"
}
var shop_poi:Dictionary = {
	"poi_code":1,
	"img_selector":"",
	"shop_type":Shop_Type.DICE,
	"inventory":[]
	}
var event_poi:Dictionary = {
	"poi_code":2,
	"img_selector":"",
	"event_type":Event_Type.BASIC,
	"event_data":""
}
var miniboss_poi:Dictionary = {
	"poi_code":3,
	"img_selector":"",
	"enemies":[],
	"reward":"gold"
}
var boss_poi:Dictionary = {
	"poi_code":4,
	"img_selector":"",
	"enemies":[],
	"reward":"gold"
}
var test_poi:Dictionary = {
	"poi_code":5,
	"img_selector":"res://icon.svg",
	"enemies":[],
	"reward":"gold"
}




##Basic EVENTS##
var test_event_data = {
	"title":"Bofa",
	"body":"Deez big black balls",
	"options":[{"yes":Event_Results.ADDITEM}, {"no":Event_Results.STARTTRAP}],
	"option_text":["Bofa Deez Big Black Balls Have given you grace (ADD HP MAJOR)", "Bofa Deez Nutz Slappin you in the Jaw (GANG OF WOLVES)"],
	"bg_img":"",
	"splash_img":"",
	"enemies":["wolf","wolf","wolf"]
}
var ancient_shrine_event = { 
	"title": "Ancient Shrine",
	"body": "You stumble upon an ancient stone shrine glowing faintly. A carved inscription invites you to touch the central gem.",
	"options": [{"touch stone": Event_Results.ADDHPMINOR}, {"leave it alone": Event_Results.NOTHING}],
	"option_text": ["You reach out and touch the gem. A warmth spreads through your body. (+Minor HP)","You leave the shrine undisturbed and walk away. (Nothing happens)"],
	"bg_img": "",
	"splash_img": ""
}
var whispering_void_event = { 
	"title": "The Whispering Void",
	"body": "A swirling black rift opens in your path. Whispers crawl into your mind, promising power... or ruin. Will you listen?",
	"options": [{"listen closely": Event_Results.STARTBATTLE}, {"flee": Event_Results.LOSSHPMINOR}],
	"option_text": ["You step closer. A shadowy figure emerges from the void. (Start Battle)","You cover your ears and flee, but the whispers leave scars on your soul. (Lose Minor HP)"],
	"bg_img": "",
	"splash_img": ""
}
var gambler_spirit_event = { 
	"title": "The Gambler’s Spirit",
	"body": "A translucent figure materializes beside a flickering campfire. Clad in tattered casino garb, it offers you a single roll of spectral dice. 'Double or nothing,' it whispers.",
	"options": [{"roll the dice": Event_Results.ADDDICE}, {"refuse offer": Event_Results.LOSSHPMINOR}],
	"option_text": ["You take the dice and roll. The ghost cackles as new luck flows through you. (Gain a Dice)","You walk away. A spectral lash cuts your back for declining fate. (Lose Minor HP)"],
	"bg_img": "",
	"splash_img": ""
}
var fallen_warrior_event = { 
	"title": "Fallen Warrior",
	"body": "You discover the body of a warrior, long dead but still clutching their weapon. A faded journal lies nearby, its final words etched in blood: 'May my blade find another worthy hand.'",
	"options": [
		{"Take the blade and honor them": Event_Results.ADDITEM}, 
		{"Say a prayer and move on": Event_Results.ADDHPMINOR}
	],
	"option_text": [
		"You lift the weapon gently, swearing to carry on their fight. (Gain Item)",
		"You kneel, offering a silent prayer. A calm warmth fills your chest. (Gain Minor HP)"
	],
	"bg_img": "",
	"splash_img": ""
}
var echoes_bell_event = { 
	"title": "Echoes of the Bell",
	"body": "A massive rusted bell hangs from a crumbling stone arch. A sign reads: 'Ring only when ready to face the echoes of your past.'",
	"options": [
		{"Ring the bell": Event_Results.STARTBATTLE}, 
		{"Walk past in silence": Event_Results.NOTHING}
	],
	"option_text": [
		"You ring the bell. The air grows cold. A shadow with your face steps from the fog. (Start Battle)",
		"You ignore it and keep walking. Some doors are better left closed. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var wishing_pebble_event = { 
	"title": "Wishing Pebble",
	"body": "A smooth, round stone sits in a shallow pond. Etched on its surface is: 'Make a wish, but only once.' You feel oddly hopeful.",
	"options": [
		{"Make a wish": Event_Results.ADDHPMINOR}, 
		{"Skip the nonsense": Event_Results.NOTHING}
	],
	"option_text": [
		"You close your eyes and make a wish. Something inside you feels lighter. (+Minor HP)",
		"You scoff and move on. Life has enough weirdness already. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var empty_cage_event = { 
	"title": "Empty Cage",
	"body": "An iron cage lies open in the center of a clearing. The ground is scorched around it. Whatever was inside... isn’t anymore.",
	"options": [
		{"Investigate the cage": Event_Results.STARTTRAP}, 
		{"Back away carefully": Event_Results.NOTHING}
	],
	"option_text": [
		"You examine the scorch marks — too late. A trap sigil flashes beneath your feet. (Start Trap)",
		"You step away cautiously. Some mysteries can stay unsolved. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var cracked_mirror_event = { 
	"title": "Cracked Mirror",
	"body": "You find a tall, cracked mirror standing upright in the middle of the road. Your reflection moves just a half-second out of sync.",
	"options": [
		{"Touch the mirror": Event_Results.LOSSHPMINOR}, 
		{"Look away and keep walking": Event_Results.NOTHING}
	],
	"option_text": [
		"Your fingers graze the glass and a shard pierces your hand. (Lose Minor HP)",
		"You avert your eyes. You’ve seen enough weirdness for one day. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var forgotten_pack_event = { 
	"title": "Forgotten Pack",
	"body": "Abandoned in a patch of tall grass lies a worn adventurer’s pack. It doesn’t appear to be trapped… but it also seems *too* convenient.",
	"options": [
		{"Check the contents": Event_Results.ADDITEM}, 
		{"Leave it untouched": Event_Results.NOTHING}
	],
	"option_text": [
		"You cautiously open the pack. Inside, a useful item has survived the elements. (Gain Item)",
		"You decide not to tempt fate. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var bubbling_spring_event = { 
	"title": "Bubbling Spring",
	"body": "Crystal-clear water bubbles up from a small spring. A weathered plaque reads: 'He who drinks will find strength, or sorrow.'",
	"options": [
		{"Drink the water": Event_Results.LOSSHPMAJOR}, 
		{"Splash some on your face": Event_Results.ADDHPMINOR}
	],
	"option_text": [
		"You drink deeply. Pain wracks your body — it was cursed. (Lose Major HP)",
		"You splash your face. It's refreshing and soothing. (Gain Minor HP)"
	],
	"bg_img": "",
	"splash_img": ""
}
var wandering_bard_event = { 
	"title": "Wandering Bard",
	"body": "A ragged bard sits by the roadside, strumming a broken lute. He offers to sing a song in exchange for nothing. Literally nothing.",
	"options": [
		{"Listen to the song": Event_Results.NOTHING}, 
		{"Ignore the bard": Event_Results.NOTHING}
	],
	"option_text": [
		"The tune is haunting, beautiful… and ultimately meaningless. (Nothing happens)",
		"You pass without a word. He keeps strumming. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var tooth_stone_event = { 
	"title": "Tooth in the Stone",
	"body": "Instead of a sword, a giant tooth is embedded in a sacred stone. It hums with strange energy. Gross, but intriguing.",
	"options": [
		{"Pull the tooth": Event_Results.ADDDICE}, 
		{"Poke it with a stick": Event_Results.STARTTRAP}
	],
	"option_text": [
		"You yank it free. It transforms into a lucky charm in your hand. (Gain Dice)",
		"You prod it. The ground bursts open and sprays you with venom gas. (Start Trap)"
	],
	"bg_img": "",
	"splash_img": ""
}
var hollow_tree_event = { 
	"title": "Hollow Tree",
	"body": "A tree with a hollow trunk whistles softly in the wind. Inside, something glints… and something else *moves*.",
	"options": [
		{"Reach inside": Event_Results.STARTBATTLE}, 
		{"Leave it be": Event_Results.NOTHING}
	],
	"option_text": [
		"A hidden creature lunges at your arm! (Start Battle)",
		"You decide to avoid the risk. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var traveling_toad_event = { 
	"title": "Traveling Toad",
	"body": "A toad wearing a tiny scarf hops up to you, ribbits twice, and presents a single die with its tongue.",
	"options": [
		{"Take the gift": Event_Results.ADDDICE}, 
		{"Politely decline": Event_Results.NOTHING}
	],
	"option_text": [
		"You accept the gift. The toad nods and hops away. (Gain Dice)",
		"You bow slightly and walk on. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var nameless_grave_event = { 
	"title": "Grave with No Name",
	"body": "A lone grave sits off the trail, unmarked and untouched. A strange warmth surrounds it.",
	"options": [
		{"Say a few words": Event_Results.ADDHPMINOR}, 
		{"Dig it up": Event_Results.LOSSHPMAJOR}
	],
	"option_text": [
		"You offer a respectful word. Peace settles in your bones. (Gain Minor HP)",
		"You disturb the grave — a violent curse lashes out. (Lose Major HP)"
	],
	"bg_img": "",
	"splash_img": ""
}
var floating_pie_event = { 
	"title": "Floating Pie",
	"body": "A steaming pie floats midair in a glowing circle. It smells like... everything you’ve ever loved.",
	"options": [
		{"Eat it immediately": Event_Results.LOSSHPMINOR}, 
		{"Lick it and run": Event_Results.ADDHPMINOR}
	],
	"option_text": [
		"You devour it. It explodes in your gut. (Lose Minor HP)",
		"You lick the crust and bolt. It heals a surprising amount. (Gain Minor HP)"
	],
	"bg_img": "",
	"splash_img": ""
}
var forgotten_doll_event = { 
	"title": "Forgotten Doll",
	"body": "A small porcelain doll leans against a tree. Its eyes follow you. It blinks.",
	"options": [
		{"Pick it up": Event_Results.STARTTRAP}, 
		{"Nod respectfully": Event_Results.NOTHING}
	],
	"option_text": [
		"You pick it up. It cackles and a trap is triggered! (Start Trap)",
		"You nod and walk away slowly. The doll closes its eyes. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var ancient_lantern_event = { 
	"title": "Ancient Lantern",
	"body": "A glowing lantern hangs from an invisible hook, swaying slightly even in still air.",
	"options": [
		{"fan the flame": Event_Results.ADDHPMAJOR}, 
		{"Ignore the weirdness": Event_Results.NOTHING}
	],
	"option_text": [
		"You fan the flame. A holy warmth surges through you. (Gain Major HP)",
		"You leave the lantern untouched. Best not to meddle. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var cursed_music_box_event = { 
	"title": "Cursed Music Box",
	"body": "A small music box plays by itself in the ruins. The melody is sad, yet beautiful.",
	"options": [
		{"Let it finish": Event_Results.ADDITEM}, 
		{"Shut it abruptly": Event_Results.STARTTRAP}
	],
	"option_text": [
		"You listen to the end. A hidden compartment opens. (Gain Item)",
		"You slam it shut — a trap snaps from beneath. (Start Trap)"
	],
	"bg_img": "",
	"splash_img": ""
}
var empty_pedestal_event = { 
	"title": "The Empty Pedestal",
	"body": "An ornate pedestal stands in the center of the glade. Whatever it held is long gone.",
	"options": [
		{"Place your hand on it": Event_Results.NOTHING}, 
		{"Search around it": Event_Results.LOSSHPMINOR}
	],
	"option_text": [
		"You place your hand — nothing happens. Disappointing. (Nothing happens)",
		"You search too close and cut yourself on the cracked stone. (Lose Minor HP)"
	],
	"bg_img": "",
	"splash_img": ""
}
var blood_stained_map_event = {
	"title": "Blood-Stained Map",
	"body": "You find a torn map with bloodstains leading off the main path. It's crudely drawn, but recent.",
	"options": [
		{"Follow the map": Event_Results.STARTTRAP},
		{"Burn it": Event_Results.NOTHING}
	],
	"option_text": [
		"You follow the trail and walk right into a trap. (Start Trap)",
		"You burn the map and move on. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var stone_of_whispers_event = {
	"title": "Stone of Whispers",
	"body": "A stone hums with low whispers. It calls your name in a voice not quite your own.",
	"options": [
		{"Listen closer": Event_Results.LOSSHPMAJOR},
		{"Plug your ears": Event_Results.NOTHING}
	],
	"option_text": [
		"The whispers flood your mind, leaving you drained. (Lose Major HP)",
		"You resist the temptation and move on. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var goblin_tollbooth_event = {
	"title": "Goblin Tollbooth",
	"body": "A group of goblins has set up a tollbooth blocking your path. They ask for a joke or a fight.",
	"options": [
		{"Tell a joke": Event_Results.ADDHPMINOR},
		{"Refuse to engage": Event_Results.STARTBATTLE}
	],
	"option_text": [
		"You tell a terrible pun. They love it. One heals you with fungus water. (Gain Minor HP)",
		"You grunt and push through. They attack with rusty forks. (Start Battle)"
	],
	"bg_img": "",
	"splash_img": ""
}
var snoring_boulder_event = {
	"title": "The Snoring Boulder",
	"body": "A massive boulder is snoring. Literally. It occasionally mutters about taxes.",
	"options": [
		{"Kick it": Event_Results.LOSSHPMINOR},
		{"Let it sleep": Event_Results.NOTHING}
	],
	"option_text": [
		"You kick it. It rolls and smacks you with a dream-snore. (Lose Minor HP)",
		"You respect its rest and leave quietly. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var lost_traveler_event = {
	"title": "Lost Traveler",
	"body": "A dazed traveler approaches you, asking for directions. They seem harmless... probably.",
	"options": [
		{"Guide them": Event_Results.ADDITEM},
		{"Ignore them": Event_Results.NOTHING}
	],
	"option_text": [
		"You help them. Grateful, they hand you a strange charm. (Gain Item)",
		"You walk past. Not your problem. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var crate_of_screams_event = {
	"title": "Crate of Screams",
	"body": "A wooden crate rocks violently and emits muffled screams. It’s labeled 'DO NOT OPEN (seriously)'.",
	"options": [
		{"Open it": Event_Results.STARTBATTLE},
		{"Leave it be": Event_Results.NOTHING}
	],
	"option_text": [
		"You pry it open. A screaming mimic lunges! (Start Battle)",
		"You let someone else be the idiot. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var buried_satchel_event = {
	"title": "Buried Satchel",
	"body": "You notice a patch of disturbed earth beneath a crooked tree. A bit of cloth peeks out from the soil.",
	"options": [
		{"Dig it up": Event_Results.ADDITEM},
		{"Leave it alone": Event_Results.NOTHING}
	],
	"option_text": [
		"You dig carefully and uncover a satchel with a useful item inside. (Gain Item)",
		"You choose not to risk whatever’s inside. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var gift_from_sky_event = {
	"title": "Gift from the Sky",
	"body": "A glowing streak cuts across the sky. Moments later, something crashes nearby with a soft thud.",
	"options": [
		{"Investigate the crater": Event_Results.ADDITEM},
		{"Ignore it": Event_Results.NOTHING}
	],
	"option_text": [
		"You approach and find a strange item embedded in the soil. (Gain Item)",
		"You continue on your way, wary of strange lights. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var old_mans_offer_event = {
	"title": "Old Man’s Offer",
	"body": "An old man sits on a stump, flipping a coin. Without looking up, he says, 'Take this. It helped me once.'",
	"options": [
		{"Accept the gift": Event_Results.ADDITEM},
		{"Refuse politely": Event_Results.NOTHING}
	],
	"option_text": [
		"You accept his gift and nod in thanks. (Gain Item)",
		"You thank him but decline. He shrugs and flips his coin. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var wreckage_path_event = {
	"title": "Wreckage on the Path",
	"body": "You come across the remains of a smashed cart. Among the debris is something that still seems intact.",
	"options": [
		{"Search the wreckage": Event_Results.ADDITEM},
		{"Keep walking": Event_Results.NOTHING}
	],
	"option_text": [
		"You find something useful left behind by its former owner. (Gain Item)",
		"You decide not to scavenge out of respect. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var cursed_carnival_event = {
	"title": "Cursed Carnival Booth",
	"body": "A rundown game booth appears out of nowhere. A sign reads: 'One toss. One prize. One fate.'",
	"options": [
		{"Play the game": Event_Results.ADDDICE},
		{"Nope out": Event_Results.NOTHING}
	],
	"option_text": [
		"You throw the ring. A ghostly clown giggles as a die materializes in your hand. (Gain Dice)",
		"You back away slowly. This is above your pay grade. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var lucky_spirit_event = {
	"title": "Drunken Lucky Spirit",
	"body": "A translucent spirit stumbles by with a bottle in one hand and dice in the other. 'Wanna swap stories?' it slurs.",
	"options": [
		{"Share a tale": Event_Results.ADDDICE},
		{"Keep walking": Event_Results.NOTHING}
	],
	"option_text": [
		"You share your best tale. The spirit laughs and hands you its dice. (Gain Dice)",
		"You decline. The spirit toasts the air and disappears. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var sacred_pool_event = {
	"title": "Sacred Pool",
	"body": "A crystal-clear pool reflects the sky perfectly, even when clouds pass. It radiates divine calm.",
	"options": [
		{"Bathe in the waters": Event_Results.ADDHPMAJOR},
		{"Sit quietly": Event_Results.NOTHING}
	],
	"option_text": [
		"You step in and are healed by the sacred waters. (Gain Major HP)",
		"You sit peacefully nearby and move on. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var travelers_camp_event = {
	"title": "Traveler’s Camp",
	"body": "You find an abandoned camp. A pot of soup still steams gently over the fire, and bedrolls look barely used.",
	"options": [
		{"Rest and eat": Event_Results.ADDHPMAJOR},
		{"Keep moving": Event_Results.NOTHING}
	],
	"option_text": [
		"You rest and dine. The meal heals you completely. (Gain Major HP)",
		"You don’t trust abandoned hospitality. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var aura_bloom_event = {
	"title": "Aura Bloom",
	"body": "A radiant flower pulses with energy, its petals shifting through colors with every heartbeat.",
	"options": [
		{"Touch the petals": Event_Results.ADDHPMAJOR},
		{"Observe from afar": Event_Results.NOTHING}
	],
	"option_text": [
		"You touch the bloom. A surge of vitality floods through you. (Gain Major HP)",
		"You admire the flower, but don’t interfere. (Nothing happens)"
	],
	"bg_img": "",
	"splash_img": ""
}
var basic_event_array = [whispering_void_event]
#commented for testing
#var basic_event_array = [
#	ancient_shrine_event,
#	whispering_void_event,
#	gambler_spirit_event,
#	fallen_warrior_event,
#	echoes_bell_event,
#	wishing_pebble_event,
#	empty_cage_event,
#	cracked_mirror_event,
#	forgotten_pack_event,
#	bubbling_spring_event,
#	wandering_bard_event,
#	tooth_stone_event,
#	hollow_tree_event,
#	traveling_toad_event,
#	nameless_grave_event,
#	floating_pie_event,
#	forgotten_doll_event,
#	ancient_lantern_event,
#	cursed_music_box_event,
#	empty_pedestal_event,
#	blood_stained_map_event,
#	stone_of_whispers_event,
#	goblin_tollbooth_event,
#	snoring_boulder_event,
#	lost_traveler_event,
#	crate_of_screams_event,
#	buried_satchel_event,
#	gift_from_sky_event,
#	old_mans_offer_event,
#	wreckage_path_event,
#	cursed_carnival_event,
#	lucky_spirit_event,
#	sacred_pool_event,
#	travelers_camp_event,
#	aura_bloom_event] 


#Wish Codes
#0:attack up
#1:defend up
#2:heal power up
#3:free item
#4:free charm
#5:free upgrade
#6:free dice
#7:max hp up
#8:free gold

#Well Event stuff
var valid_wishes = [
  {
	"triggers": ["attack","strength", "power", "might", "fury", "rage", "assault", "strike", "onslaught", "attack", "force"],
	"wish_code": 0
  },
  {
	"triggers": ["defend","shield", "guard", "protection", "barrier", "defense", "bulwark", "fortify", "aegis", "ward", "cover"],
	"wish_code": 1
  },
  {
	"triggers": [ "renewal", "heal", "remedy", "restore", "healing", "mend", "invigorate", "recover", "refresh", "revive"],
	"wish_code": 2
  },
  {
	"triggers": ["item", "gift", "boon", "reward", "present", "favor", "prize", "offering", "windfall", "bonus", "grant"],
	"wish_code": 3
  },
  {
	"triggers": ["trinket", "charm", "fortune", "serendipity", "blessing", "omen", "token", "favor", "talisman", "destiny"],
	"wish_code": 4
  },
  {
	"triggers": ["ascend", "enhance", "elevate", "upgrade", "improve", "advance", "amplify", "boost", "refine", "empower"],
	"wish_code": 5
  },
  {
	"triggers": ["chance", "roll", "fate", "destiny", "luck", "dice", "random", "gamble", "fortune", "spin"],
	"wish_code": 6
  },
  {
	"triggers": ["max hp", "life", "endurance", "resilience", "vigor", "vitality", "health", "constitution", "stamina", "longevity", "fortitude"],
	"wish_code": 7
  },
  {
	"triggers": ["wealth", "riches", "treasure", "gold", "fortune", "bounty", "windfall", "loot", "coins", "prosperity"],
	"wish_code": 8
  }
]
var wish_results:Dictionary = {
	0:["Your muscles surge with power. Your attacks will strike harder!","A burning spirit awakens within. Your blows carry new strength.","You feel unstoppable. Your next attacks will devastate your foes."],
	1:["A shimmering barrier surrounds you. Your defenses grow stronger.","You feel unbreakable. Nothing will get through your guard easily now.","An unseen shield embraces you. Incoming damage will be lessened."],
	2:["A gentle light wraps around you. Your healing magic is now more potent.","Your touch carries new life. Healing will mend deeper wounds.","Restorative energy flows within. Your healing grows more effective."],
	3:["A mysterious gift materializes before you. You have received a new item!","A helpful tool appears in your hand. Use it wisely.","An unexpected boon is granted. An item is yours to keep."],
	4:["Fortune smiles upon you. A new charm has been granted!","Luck favors you with a fresh charm. Its magic is now yours.","You sense destiny aligning. A new charm has joined your collection."],
	5:["Your gear glows with radiant energy. It has been upgraded!","A surge of magic improves your equipment. It feels stronger now.","Your tools evolve before your eyes. You've gained an upgrade!"],
	6:["Fate lends you a hand. You receive an extra dice to aid your journey!","A new die clatters into your palm. Luck is on your side.","Chance smiles at you. Another dice joins your arsenal."],
	7:["Vital energy floods your body. Your maximum health has increased!","You feel hardier than before. Your life force grows stronger.","Your vitality swells. Your health can now withstand more."],
	8:["Coins rain from nowhere. Your wealth grows instantly!","Golden riches shimmer before you. Your purse feels heavier.","A treasure manifests at your feet. Your coffers overflow."]
}

var test_rolloff_event_data:Dictionary = {
	"title":"bofa deez",
	"body":"bofa deez nuts rubbing across your chin",
	"choices":[{
		"text":"accept bofa",
		"required_dice":[5],
		"success_result": Event_Results.ADDHPMAJOR,
		"fail_result":Event_Results.NOTHING},
		{"text":"refuse bofa",
		"required_dice":[0,0,0],
		"success_result": Event_Results.NOTHING,
		"fail_result":Event_Results.LOSSHPMAJOR},]
}
