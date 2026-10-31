extends Resource
class_name Quest

enum QUEST_TYPE {
	MAIN,
	SIDE
}

@export var quest_type: QUEST_TYPE
@export var quest_title: String
@export_multiline var description: String

@export var steps: Array[String]

@export var shards: int
@export var cash: int

@export var quest_progression: int
@export var quest_completed: bool
