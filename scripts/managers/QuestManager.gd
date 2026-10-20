extends Node

var active_quest: Quest
var current_quests: Array[Quest]
var completed_quests: Array[Quest]

func start_quest(quest: Quest) -> void:
	active_quest = quest
	current_quests.append(active_quest)
	print(active_quest.quest_title)
	print(active_quest.steps[active_quest.quest_progression])

##Updates the quest status.
func update_quest() -> void:
	active_quest.quest_progression += 1
	if active_quest.quest_progression == active_quest.steps.size():
		active_quest.quest_completed = true
		give_quest_reward()
	else:
		print(active_quest.steps[active_quest.quest_progression])

##Gives Cash and Shards to player.
func give_quest_reward() -> void:
	DataManager.cash += active_quest.cash
	DataManager.shards += active_quest.shards
	
	print(active_quest.shards)
	print(active_quest.cash)
	
	completed_quests.append(active_quest)
	current_quests.erase(active_quest)
	active_quest = null

func sort_quests() -> void:
	pass
