extends Node

var player_states: Dictionary[String, BasePlayerState] = {
	"idle": IdlePlayerState.new(),
	"move": MovePlayerState.new(),
	"attack": AttackPlayerState.new(),
	"special_attack": SpecialAttackPlayerState.new(),
	"synergy_attack": SynergyAttackPlayerState.new(),
	"counter_attack": CounterAttackPlayerState.new(),
	"hurt": HurtPlayerState.new(),
	"dodge": DodgePlayerState.new(),
	"death": DeathPlayerState.new(),
	"switch": SwitchPlayerState.new(),
	"block": BlockPlayerState.new(),
	"counter": CounterPlayerState.new(),
}

var cpu_states: Dictionary[String, BaseCPUState] = {
	"idle": IdleCPUState.new(),
	"hunt": HuntCPUState.new(),
	"hurt": HurtCPUState.new(),
	"attack": AttackCPUState.new(),
	"synergy_attack": SynergyAttackCPUState.new(),
	"back_away": BackAwayCPUState.new(),
	"circle": CircleCPUState.new()
}

var enemy_states: Dictionary[String, BaseEnemyState] = {
	"idle": IdleEnemyState.new(),
	"hunt": HuntEnemyState.new(),
	"hurt": HurtEnemyState.new(),
	"death": DeathEnemyState.new(),
	"attack": AttackEnemyState.new(),
	"back_away": BackAwayEnemyState.new(),
	"circle": CircleEnemyState.new(),
	"countered": CounteredEnemyState.new()
}
