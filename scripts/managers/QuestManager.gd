extends Node

signal quest_started(q: Quest)
signal quest_updated(q: Quest)
signal quest_completed(q: Quest)
signal current_quests_updated
signal completed_quests_updated


var active_quest: Quest
var current_quests: Array[Quest]
var completed_quests: Array[Quest]

func start_quest(quest: Quest) -> void:
	active_quest = quest
	if current_quests.has(active_quest) == false:
		current_quests.append(active_quest)
		current_quests_updated.emit()
	quest_started.emit(active_quest)

##Updates the quest status.
func update_quest() -> void:
	active_quest.quest_progression += 1
	if active_quest.quest_progression == active_quest.steps.size():
		active_quest.quest_completed = true
		give_quest_reward()
	else:
		quest_updated.emit(active_quest)

##Gives Cash and Shards to player.
func give_quest_reward() -> void:
	DataManager.cash += active_quest.cash
	DataManager.shards += active_quest.shards
	quest_completed.emit(active_quest)
	
	print(DataManager.cash)
	print(DataManager.shards)
	
	completed_quests.append(active_quest)
	current_quests.erase(active_quest)
	
	completed_quests_updated.emit()
	current_quests_updated.emit()
	
	active_quest = null

func sort_quests() -> void:
	pass
