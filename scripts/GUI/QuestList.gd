extends FoldableContainer
class_name QuestList

@onready var steps: Label = $VBoxContainer/Steps
@onready var description: Label = $VBoxContainer/Description

var quest: Quest

func _ready() -> void:
	title = quest.quest_title
	description.text = quest.description
	
	if quest.quest_completed == true:
		steps.text = "Cash: %d Shards: %d" % [quest.cash, quest.shards]
	else:
		steps.text = str("\n".join(quest.steps))
