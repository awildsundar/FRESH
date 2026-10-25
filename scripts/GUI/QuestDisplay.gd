extends MarginContainer
class_name QuestDisplay

@onready var quest_name: Label = $VBoxContainer/QuestName
@onready var quest_step: Label = $VBoxContainer/QuestStep


func _ready() -> void:
	quest_name.text = ""
	quest_step.text = ""
	QuestManager.connect("quest_started", quest_started)
	QuestManager.connect("quest_updated", quest_updated)
	QuestManager.connect("quest_completed", quest_completed)

func quest_started(quest: Quest) -> void:
	quest_name.text = quest.quest_title
	quest_step.text = quest.steps[quest.quest_progression]

func quest_updated(quest: Quest) -> void:
	quest_step.text = quest.steps[quest.quest_progression]

func quest_completed(quest: Quest) -> void:
	quest_name.text = quest.quest_title
	quest_step.text = "Cash: %d \n Shards: %d" % [quest.cash, quest.shards]
	await get_tree().create_timer(1.5).timeout
	quest_name.text = ""
	quest_step.text = ""
