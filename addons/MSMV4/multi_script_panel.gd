@tool
extends Panel  # Changed from Control to Panel for better background styling

const ThemeManager = preload("res://addons/MSMV4/theme_manager.gd")
const ScriptEntryManager = preload("res://addons/MSMV4/script_entry_manager.gd")
const FileManager = preload("res://addons/MSMV4/file_manager.gd")

var plugin_ref
var theme_manager: ThemeManager
var script_manager: ScriptEntryManager
var file_manager: FileManager

# UI Components
var main_container
var header_panel
var theme_button_purple
var theme_button_black
var content_area
var scripts_container
var bottom_panel
var generate_button
var next_button
var create_button
var count_spinbox

# Particle system
var particle_container
var particles = []

# States
var current_state = "input"  # "input", "folder_selection", "ready"
var folder_selection_container

# Theme elements that need updating
var all_labels = []
var all_line_edits = []

func _ready():
	setup_managers()
	setup_ui()
	setup_particle_system()
	apply_initial_theme()
	
	# Start particle animation
	start_particle_animation()

func setup_plugin_reference(plugin):
	plugin_ref = plugin

func setup_managers():
	# Initialize managers properly - remove the const references
	theme_manager = ThemeManager.new()
	script_manager = ScriptEntryManager.new()
	file_manager = FileManager.new()
	
	# Setup references
	if script_manager and theme_manager:
		script_manager.setup_references(theme_manager)
	if file_manager:
		file_manager.setup_plugin_reference(plugin_ref)
		file_manager.setup_main_panel_reference(self)  # For dialogs

func setup_particle_system():
	particle_container = Control.new()
	particle_container.anchor_left = 0.0
	particle_container.anchor_top = 0.0
	particle_container.anchor_right = 1.0
	particle_container.anchor_bottom = 1.0
	particle_container.offset_left = 0
	particle_container.offset_right = 0
	particle_container.offset_top = 0
	particle_container.offset_bottom = 0
	particle_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	particle_container.z_index = -1
	add_child(particle_container)

	# Wait until the panel has proper size before creating particles
	call_deferred("create_particles_deferred")

func create_particles_deferred():
	# Get the actual size of the panel
	var panel_size = size
	if panel_size.x <= 0 or panel_size.y <= 0:
		# If size is still invalid, try again next frame
		await get_tree().process_frame
		panel_size = size
	
	print("Creating particles for panel size: ", panel_size)
	
	# Increase particle count and add variety
	for i in range(40):
		create_enhanced_particle(panel_size)
	
	# Start particle animation
	start_particle_animation()

# Update the create_enhanced_particle function to accept size parameter:
func create_enhanced_particle(panel_size: Vector2):
	var particle = Control.new()
	particle.size = Vector2(randf_range(3, 8), randf_range(3, 8))
	particle.position = Vector2(
		randf() * panel_size.x,
		randf() * panel_size.y
	)
	
	# Rest of the function remains the same...
	var particle_rect = ColorRect.new()
	
	# Different particle types for more variety
	var particle_type = randi() % 3
	match particle_type:
		0:  # Glowing dots
			particle_rect.color = Color(0.6, 0.4, 1.0, randf_range(0.2, 0.5))
		1:  # Soft purple
			particle_rect.color = Color(0.8, 0.6, 1.0, randf_range(0.15, 0.4))
		2:  # Bright accents
			particle_rect.color = Color(0.4, 0.2, 0.9, randf_range(0.1, 0.3))
	
	particle_rect.size = particle.size
	particle.add_child(particle_rect)
	
	particle_container.add_child(particle)
	particles.append(particle)
	
	# Add rotation for some particles
	if randf() > 0.5:
		particle.rotation = randf() * PI * 2

func start_particle_animation():
	# Animate each particle independently with simpler, more reliable approach
	for i in range(particles.size()):
		animate_particle_simple(particles[i], i)

func animate_particle_simple(particle: Control, index: int):
	var tween = create_tween()
	tween.set_loops()
	tween.set_parallel(true)
	
	# Simple floating motion
	var base_duration = randf_range(3.0, 6.0)
	var float_distance = randf_range(20, 50)
	
	# Use simple property tweens instead of method tweens to avoid binding issues
	var start_y = particle.position.y
	var target_y = start_y + float_distance
	
	# Vertical float using simple property animation
	tween.tween_property(particle, "position:y", target_y, base_duration / 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(particle, "position:y", start_y, base_duration / 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_delay(base_duration / 2)
	
	# Horizontal drift
	var start_x = particle.position.x
	var drift_distance = randf_range(-30, 30)
	var target_x = start_x + drift_distance
	
	tween.tween_property(particle, "position:x", target_x, base_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(particle, "position:x", start_x, base_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_delay(base_duration)
	
	# Opacity animation
	var fade_duration = randf_range(2.0, 4.0)
	var max_alpha = randf_range(0.3, 0.6)
	var min_alpha = randf_range(0.0, 0.2)
	
	tween.tween_property(particle, "modulate:a", max_alpha, fade_duration)
	tween.tween_property(particle, "modulate:a", min_alpha, fade_duration).set_delay(fade_duration)
	
	# Scale pulsing for some particles
	if index % 4 == 0:
		var pulse_scale = randf_range(0.8, 1.3)
		var pulse_duration = randf_range(1.5, 3.0)
		tween.tween_property(particle, "scale", Vector2.ONE * pulse_scale, pulse_duration)
		tween.tween_property(particle, "scale", Vector2.ONE, pulse_duration).set_delay(pulse_duration)
	
	# Rotation for some particles
	if index % 5 == 0:
		var rotation_duration = base_duration * 3
		tween.tween_property(particle, "rotation", particle.rotation + TAU, rotation_duration).set_trans(Tween.TRANS_LINEAR)

func setup_ui():
	# Main container with proper margins and spacing
	main_container = VBoxContainer.new()
	main_container.anchor_left = 0.0
	main_container.anchor_top = 0.0
	main_container.anchor_right = 1.0
	main_container.anchor_bottom = 1.0
	main_container.offset_left = 25
	main_container.offset_right = -25
	main_container.offset_top = 25
	main_container.offset_bottom = -25
	main_container.add_theme_constant_override("separation", 15)
	add_child(main_container)
	
	# Header with theme switcher
	setup_header()
	
	# Content area - make it expand properly
	setup_content_area()
	
	# Bottom panel with actions
	setup_bottom_panel()




func setup_header():
	header_panel = HBoxContainer.new()
	header_panel.add_theme_constant_override("separation", 10)
	main_container.add_child(header_panel)
	
	var title_label = Label.new()
	title_label.text = "Multi Script Maker"
	title_label.add_theme_font_size_override("font_size", 28)
	all_labels.append(title_label)
	header_panel.add_child(title_label)
	
	# Spacer
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_panel.add_child(spacer)
	
	# Theme buttons container
	var theme_container = HBoxContainer.new()
	theme_container.add_theme_constant_override("separation", 8)
	header_panel.add_child(theme_container)
	
	var theme_label = Label.new()
	theme_label.text = "Theme: "
	theme_label.add_theme_font_size_override("font_size", 14)
	all_labels.append(theme_label)
	theme_container.add_child(theme_label)
	
	theme_button_purple = Button.new()
	theme_button_purple.text = "Purple"
	theme_button_purple.custom_minimum_size = Vector2(80, 35)
	theme_button_purple.pressed.connect(_on_purple_theme_pressed)
	theme_container.add_child(theme_button_purple)
	
	theme_button_black = Button.new()
	theme_button_black.text = "Black"
	theme_button_black.custom_minimum_size = Vector2(80, 35)
	theme_button_black.pressed.connect(_on_black_theme_pressed)
	theme_container.add_child(theme_button_black)
	
	# Add separator with more space
	var separator = HSeparator.new()
	separator.custom_minimum_size.y = 30
	main_container.add_child(separator)

func setup_content_area():
	# Script count selection section
	var count_section = VBoxContainer.new()
	count_section.add_theme_constant_override("separation", 10)
	main_container.add_child(count_section)
	
	var count_label = Label.new()
	count_label.text = "How many scripts do you want to create?"
	count_label.add_theme_font_size_override("font_size", 18)
	all_labels.append(count_label)
	count_section.add_child(count_label)
	
	var count_container = HBoxContainer.new()
	count_container.add_theme_constant_override("separation", 10)
	count_section.add_child(count_container)
	
	count_spinbox = SpinBox.new()
	count_spinbox.min_value = 1
	count_spinbox.max_value = 20
	count_spinbox.value = 1
	count_spinbox.custom_minimum_size = Vector2(100, 40)
	count_spinbox.value_changed.connect(_on_script_count_changed)
	count_container.add_child(count_spinbox)
	
	generate_button = Button.new()
	generate_button.text = "Generate Script Fields"
	generate_button.custom_minimum_size = Vector2(180, 40)
	generate_button.pressed.connect(_on_generate_fields_pressed)
	count_container.add_child(generate_button)
	
	# Add separator
	var separator2 = HSeparator.new()
	separator2.custom_minimum_size.y = 20
	main_container.add_child(separator2)
	
	content_area = ScrollContainer.new()
	content_area.size_flags_vertical = Control.SIZE_EXPAND_FILL
	# Set a reasonable minimum height but allow expansion
	content_area.custom_minimum_size.y = 200
	main_container.add_child(content_area)
	
	scripts_container = VBoxContainer.new()
	scripts_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scripts_container.add_theme_constant_override("separation", 12)
	content_area.add_child(scripts_container)

func setup_bottom_panel():
	bottom_panel = VBoxContainer.new()
	bottom_panel.add_theme_constant_override("separation", 15)
	main_container.add_child(bottom_panel)
	
	# Action buttons container
	var button_container = HBoxContainer.new()
	button_container.alignment = BoxContainer.ALIGNMENT_CENTER
	button_container.add_theme_constant_override("separation", 15)
	bottom_panel.add_child(button_container)
	
	# Next button (initially hidden)
	next_button = Button.new()
	next_button.text = "Next: Choose Folders"
	next_button.custom_minimum_size = Vector2(200, 50)
	next_button.add_theme_font_size_override("font_size", 16)
	next_button.pressed.connect(_on_next_pressed)
	next_button.visible = false
	button_container.add_child(next_button)
	
	# Create button (initially hidden)
	create_button = Button.new()
	create_button.text = "Create All Scripts"
	create_button.custom_minimum_size = Vector2(200, 50)
	create_button.add_theme_font_size_override("font_size", 16)
	create_button.pressed.connect(_on_create_scripts_pressed)
	create_button.visible = false
	button_container.add_child(create_button)

func apply_initial_theme():
	if theme_manager:
		# Apply main panel background FIRST
		apply_main_panel_background()
		
		theme_manager.apply_theme_to_panel(self, theme_button_purple, theme_button_black, create_button)
		theme_manager.apply_theme_to_labels(all_labels)
		theme_manager.apply_theme_to_line_edits(all_line_edits)
		apply_button_themes()

func apply_button_themes():
	if theme_manager:
		theme_manager.apply_primary_button_theme(generate_button, theme_manager.get_current_theme_colors())
		theme_manager.apply_primary_button_theme(next_button, theme_manager.get_current_theme_colors())

func _on_script_count_changed(value):
	# Hide next button when count changes
	if next_button.visible:
		next_button.visible = false
		generate_button.visible = true

func _on_generate_fields_pressed():
	if not script_manager:
		show_message("Script manager not initialized!")
		return
		
	var count = int(count_spinbox.value)
	script_manager.clear_script_entries(scripts_container)
	
	for i in range(count):
		script_manager.add_script_entry_with_number(scripts_container, i + 1)
	
	# Show next button and hide generate button
	next_button.visible = true
	generate_button.visible = false
	current_state = "input"
	
	# Animate the generation
	animate_fields_generation()
	
	# Ensure the window can accommodate the new content
	call_deferred("adjust_window_size")

func adjust_window_size():
	# Get the window if we're in one
	var window = get_window()
	if window:
		# Calculate needed height based on content - more conservative sizing
		var needed_height = 150 + (int(count_spinbox.value) * 120) + 200  # Header + entries + bottom
		var needed_width = 750  # Reduced from 900 to make it less wide
		
		# Expand window if needed, but don't shrink below minimum
		var new_width = max(needed_width, 600)  # Minimum width reduced
		var new_height = max(needed_height, 500)  # Better minimum height
		
		# Cap maximum size for better UX
		new_width = min(new_width, 900)
		new_height = min(new_height, 800)
		
		if new_width != window.size.x or new_height != window.size.y:
			window.size = Vector2i(new_width, new_height)
			
		# Update particle positions for new size
		call_deferred("update_particles_for_resize")

func update_particles_for_resize():
	if particles.size() > 0:
		var window = get_window()
		if window:
			var new_size = window.size
			for particle in particles:
				# Redistribute particles if they're outside the new bounds
				if particle.position.x > new_size.x or particle.position.y > new_size.y:
					particle.position = Vector2(
						randf() * new_size.x,
						randf() * new_size.y
					)

func _on_next_pressed():
	if not script_manager:
		show_message("Script manager not initialized!")
		return
		
	# Validate that all scripts have names
	var empty_names = script_manager.validate_script_names()
	if not empty_names.is_empty():
		show_message("Please provide names for all scripts. Empty script fields: #" + ", #".join(empty_names))
		return
	
	# Show folder selection UI
	show_folder_selection()
	current_state = "folder_selection"
	
	# Adjust window size for folder selection
	call_deferred("adjust_window_size")

func show_folder_selection():
	if not script_manager:
		show_message("Script manager not initialized!")
		return
		
	# Clear existing folder selection if any
	if folder_selection_container:
		folder_selection_container.queue_free()
	
	# Create folder selection container
	folder_selection_container = VBoxContainer.new()
	folder_selection_container.add_theme_constant_override("separation", 15)
	
	# Add title
	var folder_title = Label.new()
	folder_title.text = "Choose folder location for each script:"
	folder_title.add_theme_font_size_override("font_size", 18)
	all_labels.append(folder_title)
	folder_selection_container.add_child(folder_title)
	
	# Add separator
	var separator = HSeparator.new()
	separator.custom_minimum_size.y = 10
	folder_selection_container.add_child(separator)
	
	# Add folder selection for each script
	var script_data = script_manager.get_script_data()
	for i in range(script_data.size()):
		var script_info = script_data[i]
		create_folder_selection_entry(script_info, i + 1)
	
	# Insert folder selection into the scroll area instead of bottom panel
	scripts_container.add_child(folder_selection_container)
	
	# Update buttons
	next_button.visible = false
	create_button.visible = true
	
	# Apply theme to new elements
	if theme_manager:
		theme_manager.apply_theme_to_labels([folder_title])
	
	# Animate entrance
	animate_folder_selection_entrance()

func create_folder_selection_entry(script_info: Dictionary, number: int):
	var entry_container = PanelContainer.new()
	entry_container.custom_minimum_size.y = 80
	folder_selection_container.add_child(entry_container)
	
	var entry_content = VBoxContainer.new()
	entry_content.anchor_left = 0.0
	entry_content.anchor_right = 1.0
	entry_content.offset_left = 20
	entry_content.offset_right = -20
	entry_content.offset_top = 10
	entry_content.offset_bottom = -10
	entry_content.add_theme_constant_override("separation", 8)
	entry_container.add_child(entry_content)
	
	# Script name label
	var script_label = Label.new()
	script_label.text = "Script #" + str(number) + ": " + script_info.original_name
	script_label.add_theme_font_size_override("font_size", 16)
	all_labels.append(script_label)
	entry_content.add_child(script_label)
	
	# Folder path input
	var folder_container = HBoxContainer.new()
	folder_container.add_theme_constant_override("separation", 10)
	entry_content.add_child(folder_container)
	
	var folder_label = Label.new()
	folder_label.text = "Folder: "
	folder_label.custom_minimum_size.x = 60
	all_labels.append(folder_label)
	folder_container.add_child(folder_label)
	
	var folder_input = LineEdit.new()
	folder_input.text = "res://scripts"
	folder_input.placeholder_text = "res://scripts"
	folder_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	folder_input.custom_minimum_size.y = 30
	all_line_edits.append(folder_input)
	folder_container.add_child(folder_input)
	
	# Browse button for folder selection
	var browse_button = Button.new()
	browse_button.text = "Browse..."
	browse_button.custom_minimum_size = Vector2(80, 30)
	browse_button.pressed.connect(_on_browse_folder_pressed.bind(folder_input))
	folder_container.add_child(browse_button)
	
	# Store folder input reference in script manager
	if script_manager and script_manager.script_entries.size() >= number:
		var script_entry = script_manager.script_entries[number - 1]
		script_entry.folder_input = folder_input
	
	# Apply theme
	if theme_manager:
		theme_manager.apply_theme_to_entry(entry_container)
		theme_manager.apply_theme_to_labels([script_label, folder_label])
		theme_manager.apply_theme_to_line_edits([folder_input])
		theme_manager.apply_button_theme(browse_button, theme_manager.get_current_theme_colors())

# In multi_script_panel.gd, replace the _on_browse_folder_pressed function with this:
func _on_browse_folder_pressed(folder_input: LineEdit):
	var file_dialog = EditorFileDialog.new()  # Use EditorFileDialog instead of FileDialog
	file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_DIR
	file_dialog.access = EditorFileDialog.ACCESS_RESOURCES
	file_dialog.current_dir = "res://"
	file_dialog.title = "Select Script Folder"
	
	# Add dialog to scene tree temporarily
	get_viewport().add_child(file_dialog)
	
	# Connect to the directory selected signal
	file_dialog.dir_selected.connect(_on_folder_selected.bind(folder_input, file_dialog))
	file_dialog.canceled.connect(_on_folder_dialog_canceled.bind(file_dialog))
	
	# Show the dialog
	file_dialog.popup_centered(Vector2i(800, 600))

func _on_folder_selected(path: String, folder_input: LineEdit, file_dialog: EditorFileDialog):
	folder_input.text = path
	file_dialog.queue_free()

func _on_folder_dialog_canceled(file_dialog: EditorFileDialog):
	file_dialog.queue_free()

func animate_folder_selection_entrance():
	if not folder_selection_container:
		return
		
	folder_selection_container.modulate.a = 0.0
	folder_selection_container.scale = Vector2(0.95, 0.95)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(folder_selection_container, "modulate:a", 1.0, 0.5)
	tween.tween_property(folder_selection_container, "scale", Vector2.ONE, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func animate_fields_generation():
	var tween = create_tween()
	tween.tween_property(scripts_container, "modulate", Color(1.1, 1.1, 1.1, 1.0), 0.15)
	tween.tween_property(scripts_container, "modulate", Color.WHITE, 0.25)

func animate_panel_entrance():
	modulate.a = 0.0
	scale = Vector2(0.95, 0.95)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 0.4)
	tween.tween_property(self, "scale", Vector2.ONE, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_purple_theme_pressed():
	if not theme_manager:
		return
		
	if theme_manager.current_theme != "purple":
		theme_manager.current_theme = "purple"
		apply_theme_changes()
		update_particle_colors()

func _on_black_theme_pressed():
	if not theme_manager:
		return
		
	if theme_manager.current_theme != "black":
		theme_manager.current_theme = "black"
		apply_theme_changes()
		update_particle_colors()

func update_particle_colors():
	# Update particle colors based on theme
	for i in range(particles.size()):
		var particle = particles[i]
		if particle and is_instance_valid(particle) and particle.get_child_count() > 0:
			var particle_rect = particle.get_child(0) as ColorRect
			if particle_rect:
				if theme_manager.current_theme == "purple":
					var particle_type = i % 3
					match particle_type:
						0:
							particle_rect.color = Color(0.6, 0.4, 1.0, randf_range(0.2, 0.5))
						1:
							particle_rect.color = Color(0.8, 0.6, 1.0, randf_range(0.15, 0.4))
						2:
							particle_rect.color = Color(0.4, 0.2, 0.9, randf_range(0.1, 0.3))
				else:  # black theme
					var particle_type = i % 3
					match particle_type:
						0:
							particle_rect.color = Color(0.6, 0.6, 0.6, randf_range(0.1, 0.3))
						1:
							particle_rect.color = Color(0.8, 0.8, 0.8, randf_range(0.08, 0.25))
						2:
							particle_rect.color = Color(0.4, 0.4, 0.4, randf_range(0.05, 0.2))

func apply_theme_changes():
	if not theme_manager:
		return
		
	# Apply main panel background FIRST
	apply_main_panel_background()
	
	# Apply theme to main panel
	theme_manager.apply_theme_to_panel(self, theme_button_purple, theme_button_black, create_button)
	
	# Apply theme to all labels
	theme_manager.apply_theme_to_labels(all_labels)
	
	# Apply theme to all line edits
	theme_manager.apply_theme_to_line_edits(all_line_edits)
	
	# Apply theme to buttons
	apply_button_themes()
	
	# Apply theme to script entries
	if script_manager:
		theme_manager.apply_theme_to_entries(script_manager.script_entries)
	
	# Apply theme to folder selection entries if they exist
	if folder_selection_container:
		for child in folder_selection_container.get_children():
			if child is PanelContainer:
				theme_manager.apply_theme_to_entry(child)
	
	# Animate theme change
	animate_theme_change()

func animate_theme_change():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.05, 1.05, 1.05, 1.0), 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3).set_ease(Tween.EASE_OUT)

func _on_create_scripts_pressed():
	if not script_manager or not file_manager:
		show_message("Managers not initialized!")
		return
		
	if script_manager.script_entries.is_empty():
		show_message("No scripts to create!")
		return
	
	# Check for duplicate script names first
	var duplicate_info = file_manager.check_for_duplicate_scripts(script_manager.script_entries)
	if duplicate_info.has_duplicates:
		var continue_creation = await show_duplicate_dialog(duplicate_info.duplicate_list)
		if not continue_creation:
			return
	
	# Create scripts with individual folder paths (this now includes folder creation dialog)
	var created_count = await file_manager.create_scripts_with_folders(script_manager.script_entries)
	
	if created_count > 0:
		if plugin_ref:
			plugin_ref.refresh_filesystem()
		var message = "Successfully created " + str(created_count) + " script(s) in their specified folders!"
		show_success_message(message)
		animate_success()
		reset_to_initial_state()
	else:
		show_message("Script creation was cancelled or no scripts were created.")

# In multi_script_panel.gd, replace the show_duplicate_dialog function with this:
func show_duplicate_dialog(duplicate_list: Array) -> bool:
	var dialog = ConfirmationDialog.new()
	dialog.title = "Duplicate Script Names Found"
	
	var duplicate_text = "The following scripts already exist in their target folders:\n\n"
	for duplicate in duplicate_list:
		duplicate_text += "• " + duplicate.script_name + " in " + duplicate.folder + "\n"
	
	duplicate_text += "\nDo you want to skip these files and create the others, or cancel the entire operation?"
	dialog.dialog_text = duplicate_text
	
	get_viewport().add_child(dialog)
	dialog.popup_centered()
	
	# Wait for user response using proper signal await
	var result = await dialog.confirmed
	dialog.queue_free()
	
	return result
func reset_to_initial_state():
	if not script_manager:
		return
		
	# Clear all entries
	script_manager.clear_script_entries(scripts_container)
	
	# Clear theme element arrays
	all_labels.clear()
	all_line_edits.clear()
	
	# Re-add the permanent labels
	if header_panel and header_panel.get_child_count() > 0:
		var title_label = header_panel.get_child(0)
		all_labels.append(title_label)
	
	# Remove folder selection if exists
	if folder_selection_container:
		folder_selection_container.queue_free()
		folder_selection_container = null
	
	# Reset buttons
	generate_button.visible = true
	next_button.visible = false
	create_button.visible = false
	
	# Reset spinbox
	count_spinbox.value = 1
	
	current_state = "input"
	
	# Reset window size to more reasonable dimensions
	var window = get_window()
	if window:
		window.size = Vector2i(750, 550)  # Better proportions, less wide
	
	# Re-apply theme to reset elements
	call_deferred("apply_initial_theme")

func show_message(text: String):
	var dialog = AcceptDialog.new()
	dialog.dialog_text = text
	dialog.title = "Multi Script Maker"
	
	# Apply theme to dialog
	if theme_manager:
		theme_manager.apply_dialog_theme(dialog)
	
	get_viewport().add_child(dialog)
	dialog.popup_centered()
	dialog.confirmed.connect(dialog.queue_free)

func show_success_message(text: String):
	show_message(text)

func animate_success():
	var tween = create_tween()
	tween.set_loops(3)
	tween.tween_property(create_button, "modulate", Color.GREEN, 0.1)
	tween.tween_property(create_button, "modulate", Color.WHITE, 0.1)

func apply_main_panel_background():
	if not theme_manager:
		return
		
	var theme_colors = theme_manager.get_current_theme_colors()
	
	# Create a beautiful background with gradient effect
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = theme_colors.background
	
	# Enhanced styling based on theme
	if theme_manager.current_theme == "purple":
		# Purple theme with magical background
		bg_style.corner_radius_top_left = 0
		bg_style.corner_radius_top_right = 0
		bg_style.corner_radius_bottom_left = 0
		bg_style.corner_radius_bottom_right = 0
		
		# Add gradient effect by using a slightly different color at the edges
		var gradient_color = Color(0.08, 0.04, 0.15, 1.0)  # Slightly lighter purple
		bg_style.bg_color = gradient_color
		
		# Optional border for the entire panel
		bg_style.border_color = Color(0.3, 0.15, 0.5, 0.3)
		bg_style.border_width_left = 1
		bg_style.border_width_right = 1
		bg_style.border_width_top = 1
		bg_style.border_width_bottom = 1
		
	else:
		# Black theme with sleek background
		bg_style.corner_radius_top_left = 0
		bg_style.corner_radius_top_right = 0
		bg_style.corner_radius_bottom_left = 0
		bg_style.corner_radius_bottom_right = 0
		
		# Deep black with subtle variation
		var gradient_color = Color(0.08, 0.08, 0.08, 1.0)
		bg_style.bg_color = gradient_color
		
		# Subtle border
		bg_style.border_color = Color(0.2, 0.2, 0.2, 0.4)
		bg_style.border_width_left = 1
		bg_style.border_width_right = 1
		bg_style.border_width_top = 1
		bg_style.border_width_bottom = 1
	
	# Apply the background style to the main panel
	add_theme_stylebox_override("panel", bg_style)

# Handle window resize to update particles
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		call_deferred("update_particles_for_resize")
