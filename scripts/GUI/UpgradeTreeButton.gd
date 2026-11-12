extends TextureButton
class_name SkillButton

enum UPGRADE_TYPE {
	SPECIAL,
	SYNERGY
}

@export var upgrade_type: UPGRADE_TYPE = UPGRADE_TYPE.SPECIAL
@export var character: CharacterResource
@export var special_attack: SpecialAttack
@export var synergy_attack: SynergyAttack

@export var share_parent: bool
@export var shared_parent: SkillButton
@export var shared_child: SkillButton

@onready var parent: Node = self.get_parent()
@onready var branch: Line2D = $Branch
@onready var branch_2: Line2D = $Branch2

var skill

func _ready() -> void:
	match upgrade_type:
		UPGRADE_TYPE.SPECIAL:
			skill = special_attack
		UPGRADE_TYPE.SYNERGY:
			skill = synergy_attack
	
	if parent is SkillButton:
		branch.add_point(branch.global_position - self.global_position)
		branch.add_point(branch.global_position - parent.global_position)
		disabled = !is_parent_unlocked()
	
	if shared_parent != null:
		branch_2.add_point(branch.global_position - self.global_position)
		branch_2.add_point(branch.global_position - shared_parent.global_position)
		disabled = !is_parent_unlocked(shared_parent)

func is_parent_unlocked(p: Node = parent) -> bool:
	if p is SkillButton:
		if p.special_attack != null:
			if p.special_attack.unlocked == false:
				return false
			else:
				return true
		elif p.synergy_attack != null:
			if p.synergy_attack.unlocked == false:
				return false
			else:
				return true
	return false

func _on_pressed() -> void:
	if skill.unlocked == false:
		if DataManager.shards >= skill.cost:
			DataManager.shards -= skill.cost
			self.self_modulate = Color.WHITE
			skill.unlocked = true
			
			if is_parent_unlocked():
				branch.default_color = Color.GREEN
			
			if is_parent_unlocked(shared_parent):
				branch_2.default_color = Color.GREEN
			
			for button in self.get_children():
				if button is SkillButton:
					button.disabled = false
			
			if skill is SpecialAttack:
				character.special_attack = skill
			else:
				DataManager.synergy_attack = skill
	else:
		if skill is SpecialAttack:
			character.special_attack = skill
		else:
			DataManager.synergy_attack = skill
	
	var skills: Array = self.get_children()
	if shared_child != null:
		skills.append(shared_child)
	
	for s: Node in skills:
		if s is SkillButton:
			s.disabled = false
