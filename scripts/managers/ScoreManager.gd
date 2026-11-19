extends Node
class_name ScoreManager

var start_time: float = 0.0
var elapsed_time: float = 0.0
var end_time: float = 0.0

var damage_taken: float = 0.0
var damage_inflicted: float = 0.0
var counters_performed: int = 0
var statuses_inflicted: int = 0
var synergy_activations: int = 0
var synergy_combos: int = 0
var synergy_multipler_activations: int = 0

var character_attacks_count: Dictionary[CharacterResource, int]

func _ready() -> void:
	start_time = Time.get_ticks_msec()

func _process(delta: float) -> void:
	elapsed_time = (Time.get_ticks_msec() - start_time)

func battle_ended() -> void:
	print("Damage Taken: " + str(damage_taken))
	print("Damage Inflicted: " + str(damage_inflicted))
	print("Counters Performed: " + str(counters_performed))
	print("Statuses Inflicted: " + str(statuses_inflicted))
	print("Synergy Activations: " + str(synergy_activations))
	print("Synergy Combos: " + str(synergy_combos))
	print("Synergy Max Multiplier Activations: " + str(synergy_multipler_activations))
	print("Time Elapsed (in msec): " + str(elapsed_time))
	
	var mvp: CharacterResource = character_attacks_count.find_key(character_attacks_count.values().max())
	print("Most Valuable Player: " + mvp.character_name)
