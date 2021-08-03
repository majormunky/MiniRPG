extends PopupPanel

onready var content = $HBoxContainer/MarginContainer/content
onready var question_list = $HBoxContainer/QuestionContainer/VBoxContainer/ItemList
onready var question_container = $HBoxContainer/QuestionContainer

signal question_response(data)

var lines = []
var current_line = null
var keep_open = false
var waiting_for_response = false
var npc_id = null


func _ready():
	question_container.visible = false


func set_content(text):
	content.text = text


func open_dialog(text_lines, maybe_npc_id = null):
	npc_id = maybe_npc_id
	lines = text_lines
	current_line = 0
	set_content(lines[current_line]["text"])
	check_for_select(lines[current_line])
	visible = true
	keep_open()


func check_for_select(line_data):
	if line_data["select"]:
		for option in line_data["select"]:
			question_list.add_item(" " + option)
		question_container.visible = true
		waiting_for_response = true
	else:
		question_container.visible = false


func keep_open():
	keep_open = true
	yield(get_tree().create_timer(0.5), "timeout")
	keep_open = false


func next():
	if waiting_for_response:
		print("We are currently waiting for a response")
		return
	
	print("In Next, passed the waiting for response check")
	current_line += 1
	if len(lines) >= current_line + 1:
		set_content(lines[current_line]["text"])
		check_for_select(lines[current_line])
		keep_open()
	else:
		close_dialog()


func close_dialog():
	set_content("")
	lines = []
	current_line = null
	npc_id = null
	question_list.clear()
	visible = false


func _on_SelectDialogButton_pressed():
	if waiting_for_response:
		var selected = question_list.get_selected_items()
		if selected:
			var selected_response = question_list.get_item_text(selected[0]).strip_edges()
			waiting_for_response = false
			question_container.visible = false
			current_line += 1
			var answer_text = lines[current_line]["select_answer"][selected_response]["text"]
			set_content(answer_text)
			
			if "action" in lines[current_line]["select_answer"][selected_response]:
				print("Found dialog action!")
				var action = lines[current_line]["select_answer"][selected_response]["action"]
				print("Action: ", action)
				emit_signal("question_response", {
					"action": action,
					"npc": npc_id,
				})
	
#	var selected = question_list.get_selected_items()
#	if selected:
#		emit_signal(
#			"question_response", 
#			{
#				"answer": lines[current_line]["select"][selected[0]], 
#				"npc": npc_id, 
#				"question": lines[current_line]
#			}
#		)
