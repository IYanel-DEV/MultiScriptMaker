@tool
extends RefCounted
class_name ScriptEntryManager

var script_entries = []
var theme_manager: ThemeManager

func setup_references(theme_mgr: ThemeManager):
	theme_manager = theme_mgr

func add_script_entry_with_number(scripts_container: VBoxContainer, number: int):
	var entry_container = PanelContainer.new()
	entry_container.custom_minimum_size.y = 100
	scripts_container.add_child(entry_container)
	
	var entry_content = VBoxContainer.new()
	entry_content.anchor_left = 0.0
	entry_content.anchor_right = 1.0
	entry_content.offset_left = 20
	entry_content.offset_right = -20
	entry_content.offset_top = 15
	entry_content.offset_bottom = -15
	entry_content.add_theme_constant_override("separation", 10)
	entry_container.add_child(entry_content)
	
	# Header with script number
	var entry_header = HBoxContainer.new()
	entry_content.add_child(entry_header)
	
	var entry_title = Label.new()
	entry_title.text = "Script #" + str(number)
	entry_title.add_theme_font_size_override("font_size", 16)
	entry_title.add_theme_color_override("font_color", Color(0.9, 0.9, 1.0))
	entry_header.add_child(entry_title)
	
	# Script name input
	var name_container = HBoxContainer.new()
	name_container.add_theme_constant_override("separation", 10)
	entry_content.add_child(name_container)
	
	var name_label = Label.new()
	name_label.text = "Script Name: "
	name_label.custom_minimum_size.x = 120
	name_label.add_theme_font_size_override("font_size", 14)
	name_container.add_child(name_label)
	
	var name_input = LineEdit.new()
	name_input.placeholder_text = "Enter script name (e.g., PlayerController)"
	name_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_input.custom_minimum_size.y = 35
	name_container.add_child(name_input)
	
	var script_entry = {
		"container": entry_container,
		"name_input": name_input,
		"folder_input": null,
		"title_label": entry_title
	}
	
	script_entries.append(script_entry)
	
	# Animate entrance with delay for staggered effect
	animate_script_entry_entrance_delayed(entry_container, number * 0.1)
	if theme_manager:
		theme_manager.apply_theme_to_entry(entry_container)

func clear_script_entries(scripts_container: VBoxContainer):
	for entry in script_entries:
		if entry.container != null:
			entry.container.queue_free()
	script_entries.clear()

func animate_script_entry_entrance_delayed(container: PanelContainer, delay: float):
	container.modulate.a = 0.0
	container.scale = Vector2(0.8, 0.8)
	
	# Use a timer instead of tween_delay which doesn't exist in Godot 4
	await container.get_tree().create_timer(delay).timeout
	
	var tween = container.create_tween()
	tween.set_parallel(true)
	tween.tween_property(container, "modulate:a", 1.0, 0.4)
	tween.tween_property(container, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_BACK)

func validate_script_names() -> Array:
	var empty_names = []
	for i in range(script_entries.size()):
		var name = script_entries[i].name_input.text.strip_edges()
		if name.is_empty():
			empty_names.append(str(i + 1))
	return empty_names

func get_script_data() -> Array:
	var script_data = []
	for entry in script_entries:
		var name = entry.name_input.text.strip_edges()
		if not name.is_empty():
			if not name.ends_with(".gd"):
				name += ".gd"
			script_data.append({
				"name": name,
				"original_name": entry.name_input.text.strip_edges()
			})
	return script_data
