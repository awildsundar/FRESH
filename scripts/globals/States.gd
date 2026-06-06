extends Node

var player_states: Dictionary[String, BasePlayerState] = {
	"idle": IdlePlayerState.new(),
	"move": MovePlayerState.new(),
	"attack": AttackPlayerState.new(),
	"hurt": HurtPlayerState.new(),
	"dash": DashPlayerState.new(),
	"death": DeathPlayerState.new(),
	"switch": SwitchPlayerState.new()
}

var cpu_states: Dictionary[String, BaseCPUState] = {
	"idle": IdleCPUState.new()
}

var enemy_states: Dictionary[String, BaseEnemyState] = {
	"idle": IdleEnemyState.new(),
	"hunt": HuntEnemyState.new(),
	"hurt": HurtEnemyState.new(),
	"death": DeathEnemyState.new(),
	"attack": AttackEnemyState.new()
}
