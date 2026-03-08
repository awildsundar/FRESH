extends PanelContainer
class_name ChoiceButton

@export var hover_scale: float = 1.2
@export var hover_time: float = 0.2
@export var easing: Tween.EaseType = Tween.EASE_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_CUBIC

@onready var choice: Button = $Button
@onready var frame: Panel = $Panel

#config vars
var colour: Color = Color("b4515b")

func _ready() -> void:
	pivot_offset = Vector2(size.x/2, size.y/2)
	
	var f_material: ShaderMaterial = frame.material
	f_material.set_shader_parameter("color2", colour)
	

func _on_button_mouse_entered() -> void:
	var enter: Tween = get_tree().create_tween()
	enter.tween_property(self, "scale", Vector2(hover_scale, hover_scale), hover_time).set_ease(easing).set_trans(trans)

func _on_button_mouse_exited() -> void:
	var exit: Tween = get_tree().create_tween()
	exit.tween_property(self, "scale", Vector2(1.0, 1.0), hover_time).set_ease(easing).set_trans(trans)
