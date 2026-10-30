extends Resource
class_name SaveData

@export var CURRENT_SAVE_VERSION: int = 1

@export var cash: int = 0
@export var shards: int = 0

@export var inventory: Dictionary[Item, int] = {}

@export var story_flags: Dictionary = {}
@export var story_act: int = 0

@export var active_quest: Quest = null
@export var current_quests: Array[Quest] = []
@export var completed_quests: Array[Quest] = []

@export var timestamp: String
