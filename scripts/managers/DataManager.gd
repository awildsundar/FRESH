extends Node

signal inventory_updated
signal shards_updated(value: int)
signal cash_updated(value: int)

const CURRENT_SAVE_VERSION: int = 1

var cash: int = 10000:
	set(value):
		cash = value
		cash_updated.emit(value)
var shards: int = 10000:
	set(value):
		shards = value
		shards_updated.emit(value)

var inventory: Dictionary[Item, int]

var story_flags: Dictionary = {}
var story_act: int = 0

var unlocked_characters: Array[CharacterResource] = [
	preload("res://resources/entities/characters/Archita.tres"),
	preload("res://resources/entities/characters/Minnie.tres"),
	preload("res://resources/entities/characters/Tom.tres")
]
var synergy_attack: SynergyAttack

var save_data: SaveData = SaveData.new()

func set_flag(flag: String, value: bool = true) -> void:
	story_flags[flag] = value

func get_flag(flag: String) -> bool:
	return story_flags.get(flag, false)

func store_data_to_resource() -> SaveData:
	save_data.CURRENT_SAVE_VERSION = CURRENT_SAVE_VERSION
	save_data.cash = cash
	save_data.shards = shards
	save_data.inventory = inventory
	save_data.active_quest = QuestManager.active_quest
	save_data.active_quest_progression = QuestManager.active_quest.quest_progression
	save_data.current_quests = QuestManager.current_quests
	save_data.completed_quests = QuestManager.completed_quests
	save_data.story_flags = story_flags
	save_data.story_act = story_act
	save_data.unlocked_characters = unlocked_characters
	save_data.synergy_attack = synergy_attack
	save_data.timestamp = Time.get_datetime_string_from_system(false, true)
	return save_data

func load_data_from_resource(data: SaveData) -> void:
	data.CURRENT_SAVE_VERSION = CURRENT_SAVE_VERSION
	cash = data.cash
	shards = data.shards
	inventory = data.inventory
	story_flags = data.story_flags
	story_act = data.story_act
	unlocked_characters = data.unlocked_characters
	synergy_attack = data.synergy_attack
	QuestManager.active_quest = data.active_quest
	QuestManager.active_quest.quest_progression = data.active_quest_progression
	QuestManager.current_quests = data.current_quests
	QuestManager.completed_quests = data.completed_quests
	QuestManager.completed_quests_updated.emit()
	QuestManager.current_quests_updated.emit()
