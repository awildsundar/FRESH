extends Control
class_name BasicDialogue

#TODO: implement logic for character expressions and speech

#node references
@export var dialogue_display: RichTextLabel
@export var ch_name: Label
@export var choice_list: VBoxContainer

#dialogue display vars
@export var default_anim_speed: float = 30.0
@export var ch_stylebox: StyleBox
var animate_text: bool = false
var current_visible_char: int = 0

#dialogue logic vars
var dialogue_lines: Array = []
var dialogue_index: int = 0
var anim_speed: float

#config vars
var timeline: String = "res://dialogues/tests/test1.json"
var ch_list: Dictionary[String, Color]
var main_ch: String = "Archita"
var important_timeline: bool = false
var cutscene_name: String
var cutscene_player: AnimationPlayer

#preloads
var choice_scene: Resource = preload("res://scenes/dialogue ui/ButtonChoice.tscn")

func play() -> void:
	SignalBus.timeline_started.emit()
	anim_speed = default_anim_speed
	dialogue_lines = load_dialogue(timeline)
	ch_name.pivot_offset = Vector2(ch_name.size.x/2, ch_name.size.y/2)
	ch_name.rotation_degrees = 3.0
	choice_list.hide()
	process_current_line()

#animates text
func _process(delta: float) -> void:
	if important_timeline:
		if animate_text:
			if dialogue_display.visible_ratio < 1:
				dialogue_display.visible_ratio += (1.0/dialogue_display.text.length()) * (anim_speed * delta)
				current_visible_char = dialogue_display.visible_characters
			else:
				animate_text = false
	else:
		dialogue_display.visible_ratio = 1

func _input(event: InputEvent) -> void:
	var line: Dictionary = dialogue_lines[dialogue_index]
	var has_choices: bool = line.has("choices")
	
	if event.is_action_pressed("advance_dialogue") && has_choices == false:
		advance_dialogue()

func load_dialogue(file_path: String) -> Variant:
	#Does the file exist?
	if not FileAccess.file_exists(file_path):
		printerr("File does not exist: " + file_path)
		return null
	
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	
	#Is file openable?
	if file == null:
		printerr("File unopenable: " + file_path)
		return null
	
	var content: String = file.get_as_text()
	var json_content: Array = JSON.parse_string(content)
	
	#Is file valid?
	if json_content == null:
		printerr("File unparsable: " + file_path)
		return null
	
	return json_content

##checks to see if dialogue is important
func advance_dialogue() -> void:
	if dialogue_display.visible_ratio == 1:
		if dialogue_index < dialogue_lines.size() - 1:
			dialogue_index += 1
			process_current_line()
		else:
			SignalBus.timeline_ended.emit()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			self.queue_free()

func process_current_line() -> void:
	var line: Dictionary = dialogue_lines[dialogue_index]
	
	match line:
		{"goto"}:
			jump_to_header(line["goto"])
			return
		
		{"header"}:
			dialogue_index += 1
			process_current_line()
			return
		
		{"speed"}:
			if important_timeline:
				anim_speed = default_anim_speed
				anim_speed = anim_speed * line["speed"]
				dialogue_index += 1
				process_current_line()
				return
		
		{"choices"}:
			SignalBus.choice_started.emit()
			create_choices(line["choices"])
			return
		{"cutscene"}:
			cutscene_player.play_section_with_markers(cutscene_name, line["cutscene"][0], line["cutscene"][1])
			dialogue_index += 1
			process_current_line()
		
		_:
			change_line(line["speaker"], line["text"])

func create_choices(choices: Array) -> void:
	for child in choice_list.get_children():
		child.queue_free()
	
	choice_list.show()
	
	for c in choices:
		var button: ChoiceButton = choice_scene.instantiate()
		choice_list.add_child(button)
		button.choice.text = c["text"]
		#button.colour = ch_colours[main_ch]
		button.choice.pressed.connect(jump_to_header.bind(c["goto"], true))

func get_header_pos(header: String) -> Variant:
	for i in range(dialogue_lines.size()):
		if dialogue_lines[i].has("header") and dialogue_lines[i]["header"] == header:
			return i
	
	printerr("Header not found:" + header)
	return null

func jump_to_header(header: String, choice: bool = false) -> void:
	dialogue_index = get_header_pos(header)
	process_current_line()
	
	if choice:
		SignalBus.choice_finished.emit()
		choice_list.hide()

##displays the current line
func change_line(speaker: String, dialogue: String) -> void:
	animate_text = true
	current_visible_char = 0
	dialogue_display.visible_characters = 0
	
	for c in ch_list.keys():
		if c == speaker:
			ch_stylebox.bg_color = ch_list[c]
	
	ch_name.text = speaker
	dialogue_display.text = dialogue
