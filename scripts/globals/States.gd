extends Node

var character_states: Dictionary[String, BaseCharacterState] = {
	"idle": IdleCharacterState.new(),
	"move": MoveCharacterState.new(),
	"attack": AttackCharacterState.new(),
	"hurt": HurtCharacterState.new(),
	"dash": DashCharacterState.new()
}

var enemy_states: Dictionary[String, BaseEnemyState] = {
	"idle": IdleEnemyState.new(),
	"hunt": HuntEnemyState.new(),
	"hurt": HurtEnemyState.new(),
	"death": DeathEnemyState.new(),
	"attack": AttackEnemyState.new()
}
