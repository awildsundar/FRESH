extends Node3D
class_name ProjectileManager

@export var mesh: Node3D
@export var hitbox: Area3D

var attacker: ArenaCharacter

var initial_position: Vector3

func _ready() -> void:
	initial_position = self.global_position
	hitbox.body_entered.connect(enemy_hit)

func _physics_process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, attacker.character.projectile_speed) * delta
	
	if self.global_position.z - initial_position.z >= attacker.character.attack_distance:
		self.queue_free()

func enemy_hit(body: Node3D) -> void:
	if body is Enemy:
		body.hurt(attacker, attacker.atk)
		self.queue_free()
