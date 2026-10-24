extends Control
class_name QuestListDisplay

@onready var current_quests: FoldableContainer = $MarginContainer/VBoxContainer/CurrentQuests
@onready var completed_quests: FoldableContainer = $MarginContainer/VBoxContainer/CompletedQuests

var quest_list_display: PackedScene = preload("uid://ilp4tlp3kbb1")

func _ready() -> void:
	QuestManager.connect("current_quests_updated", current_quests_updated)
	QuestManager.connect("completed_quests_updated", completed_quests_updated)

func current_quests_updated() -> void:
	for child in current_quests.get_children():
		child.queue_free()
	
	for quest in QuestManager.current_quests:
		var quest_display: QuestList = quest_list_display.instantiate()
		quest_display.quest = quest
		current_quests.add_child(quest_display)

func completed_quests_updated() -> void:
	for child in completed_quests.get_children():
		child.queue_free()
	
	for quest in QuestManager.completed_quests:
		var quest_display: QuestList = quest_list_display.instantiate()
		quest_display.quest = quest
		completed_quests.add_child(quest_display)
