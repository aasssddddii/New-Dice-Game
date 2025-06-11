extends Node2D

var game_manager = GameManager

@onready var dice_battle = $".."
@onready var item_inventory = $item_background
@onready var battle_item_grid = $item_background/battle_item_container

@onready var display_menu = $display_menu

@onready var deck_display_menu = $display_menu/deck
@onready var discard_display_menu = $display_menu/discard
@onready var items_display_menu = $display_menu/items

func _ready():
	dice_battle.deck_changed.connect(update_decks)

func setup_player_menu():
	#get rid of title text and replace with icon
	display_menu.set_tab_icon(0,load("res://Sprites/dice_game_ui/dice bag button.png"))
	display_menu.set_tab_title(0,"")
	display_menu.set_tab_icon(1,load("res://Sprites/dice_game_ui/discord dice bag button.png"))
	display_menu.set_tab_title(1,"")
	display_menu.set_tab_icon(2,load("res://Sprites/dice_game_ui/player inventory button.png"))
	display_menu.set_tab_title(2,"")
	#setup grid containers
	setup_deck()
	setup_item_inventory()


func setup_deck():
	print("current dice deck: ",dice_battle.current_dice_deck)
	deck_display_menu.setup_inventory(dice_battle.current_dice_deck,"battle_deck")
	pass
func setup_discard():
	
	pass
func setup_item_inventory():
	items_display_menu.setup_inventory(game_manager.player_resource.getset_inventory("get_battle",null),"battle")

func update_decks(dice_deck:Array[Dictionary],discard_deck:Array[Dictionary]):
	deck_display_menu.setup_inventory(dice_deck,"battle_deck")
	discard_display_menu.setup_inventory(discard_deck,"battle_discard")
	pass
