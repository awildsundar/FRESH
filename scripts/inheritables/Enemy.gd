extends Resource
class_name EnemyResource

#gameplay vars
@export_category("Gameplay")
@export var status_effect: StatusEffect
@export_group("Stats")
@export var base_speed: float = 5.0
@export var base_atk: float = 50.0
@export var base_def: float = 50.0
@export var base_hp: float = 100.0
@export_group("Config")
@export_subgroup("Back Away")
@export var attack_distance: float = 100.0
@export var back_away_distance: float = 1.0
@export var back_away_timer: float = 3.0
@export_range(0.1, 1.0, 0.1) var back_away_speed_mult: float = 0.5
@export_subgroup("Circle")
@export var circle_distance: float = 1.0
@export var base_min_circle_time: float = 1.0
@export var base_max_circle_time: float = 3.0
@export_range(0.1, 0.9) var base_attack_chance: float = 0.3
@export_subgroup("Misc")
@export var max_combo: int = 3
@export var rest_time: float = 0.5
@export var shards: int = 5
@export var cash: int = 10
