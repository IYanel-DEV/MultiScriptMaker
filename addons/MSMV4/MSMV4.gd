@tool
extends EditorPlugin

const MultiScriptPanel = preload("res://addons/MSMV4/multi_script_panel.gd")
var dock_panel
var toolbar_button
var main_window
var panel_script = load("res://addons/MSMV4/multi_script_panel.gd")
func _enter_tree():
	print("Multi Script Maker: Initializing plugin...")
	
	# Create toolbar button with enhanced styling
	toolbar_button = Button.new()
	toolbar_button.text = "Multi Scripts"
	toolbar_button.icon = get_editor_interface().get_base_control().get_theme_icon("Script", "EditorIcons")
	toolbar_button.pressed.connect(_on_toolbar_button_pressed)
	toolbar_button.tooltip_text = "Open Multi Script Maker - Create multiple GDScript files at once"
	
	# Add button to toolbar
	add_control_to_container(CONTAINER_TOOLBAR, toolbar_button)
	
	# Create main window with optimal settings
	setup_main_window()
	
	print("Multi Script Maker: Plugin initialized successfully!")

func setup_main_window():
	main_window = Window.new()
	main_window.title = "Multi Script Maker v4.0"
	main_window.min_size = Vector2i(700, 550)  # Better proportions - less wide
	main_window.max_size = Vector2i(1000, 900)  # More reasonable maximum
	
	# Window behavior settings
	main_window.close_requested.connect(_on_window_close_requested)
	main_window.size_changed.connect(_on_window_size_changed)
	
	# Set window flags for better behavior
	main_window.unresizable = false  # Start with fixed size, can be changed later
	main_window.borderless = false
	main_window.always_on_top = false
	
	# Add window to editor with proper hierarchy
	get_editor_interface().get_base_control().add_child(main_window)
	
	# Set optimal initial size and position
	var editor_main = get_editor_interface().get_base_control()
	var editor_size = editor_main.size
	
	# Calculate optimal window size (better proportions)
	var optimal_width = 750  # Fixed reasonable width
	var optimal_height = 550  # Fixed reasonable height
	
	main_window.size = Vector2i(optimal_width, optimal_height)
	
	# Center the window
	var center_x = int((editor_size.x - optimal_width) / 2)
	var center_y = int((editor_size.y - optimal_height) / 2)
	main_window.position = Vector2i(max(center_x, 50), max(center_y, 50))
	
	# Create and setup panel after window is properly sized
	create_dock_panel()
	
	# Hide window initially
	main_window.hide()

func create_dock_panel():
	# Clean up existing panel if any
	if dock_panel:
		dock_panel.queue_free()
		dock_panel = null
	
	# Load the script resource
	var panel_script = load("res://addons/MSMV4/multi_script_panel.gd")
	if panel_script:
		# Create instance using the script's new() method
		dock_panel = panel_script.new()  # Remove the dot before new
	else:
		print("Multi Script Maker: ERROR - Failed to load panel script!")
		return
	
	if dock_panel and dock_panel.has_method("setup_plugin_reference"):
		dock_panel.setup_plugin_reference(self)
	else:
		print("Multi Script Maker: ERROR - Panel doesn't have setup_plugin_reference method!")
		if dock_panel:
			dock_panel.queue_free()
			dock_panel = null
		return
	
	# Set panel to fill the window with proper anchoring
	dock_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dock_panel.anchor_left = 0.0
	dock_panel.anchor_top = 0.0
	dock_panel.anchor_right = 1.0
	dock_panel.anchor_bottom = 1.0
	dock_panel.offset_left = 0
	dock_panel.offset_top = 0
	dock_panel.offset_right = 0
	dock_panel.offset_bottom = 0
	
	# Ensure proper size flags
	dock_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dock_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	main_window.add_child(dock_panel)
	
	print("Multi Script Maker: Panel created and added to window")

func _on_window_size_changed():
	if dock_panel and is_instance_valid(dock_panel):
		# Ensure panel maintains full rect preset when window resizes
		dock_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		dock_panel.size = main_window.size
		
		# Force update of panel layout
		call_deferred("_update_panel_layout")

func _update_panel_layout():
	if dock_panel and is_instance_valid(dock_panel):
		dock_panel.queue_redraw()

func _exit_tree():
	print("Multi Script Maker: Cleaning up plugin...")
	
	if toolbar_button:
		remove_control_from_container(CONTAINER_TOOLBAR, toolbar_button)
		toolbar_button.queue_free()
		toolbar_button = null
	
	if main_window:
		# Properly clean up the window and its contents
		if dock_panel:
			dock_panel.queue_free()
			dock_panel = null
		
		main_window.queue_free()
		main_window = null
	
	print("Multi Script Maker: Plugin cleaned up successfully!")

func _on_toolbar_button_pressed():
	if not main_window or not dock_panel:
		print("Multi Script Maker: Window or panel not ready, reinitializing...")
		setup_main_window()
		return
	
	if not is_instance_valid(main_window) or not is_instance_valid(dock_panel):
		print("Multi Script Maker: Invalid references detected, recreating...")
		setup_main_window()
		return
	
	# Enable resizing when window is opened
	main_window.unresizable = false
	
	# Show and center the window
	main_window.popup_centered()
	
	# Bring window to front
	main_window.grab_focus()
	
	# Update window size to current content if needed
	_adjust_window_to_content()
	
	# Animate panel entrance if method exists
	if dock_panel.has_method("animate_panel_entrance"):
		dock_panel.call_deferred("animate_panel_entrance")
	
	print("Multi Script Maker: Window opened successfully")

func _adjust_window_to_content():
	if not main_window or not dock_panel:
		return
		
	# Get editor size for constraints
	var editor_main = get_editor_interface().get_base_control()
	var editor_size = editor_main.size
	
	# Ensure window doesn't exceed editor bounds
	var max_width = int(editor_size.x * 0.8)  # Reduced from 0.9 to 0.8
	var max_height = int(editor_size.y * 0.8)  # Reduced from 0.9 to 0.8
	
	var current_size = main_window.size
	var new_width = clamp(current_size.x, 700, max_width)  # Reduced minimum from 900
	var new_height = clamp(current_size.y, 550, max_height)  # Reduced minimum from 700
	
	if new_width != current_size.x or new_height != current_size.y:
		main_window.size = Vector2i(new_width, new_height)

func _on_window_close_requested():
	if main_window and is_instance_valid(main_window):
		main_window.hide()

func get_filesystem():
	var filesystem = get_editor_interface().get_resource_filesystem()
	if not filesystem:
		print("Multi Script Maker: Warning - Could not get filesystem reference")
	return filesystem

func refresh_filesystem():
	var filesystem = get_filesystem()
	if filesystem:
		filesystem.scan()
		print("Multi Script Maker: Filesystem refreshed")
	else:
		print("Multi Script Maker: Warning - Could not refresh filesystem")

# Additional utility functions for better plugin management
func is_plugin_ready() -> bool:
	return main_window != null and is_instance_valid(main_window) and dock_panel != null and is_instance_valid(dock_panel)

func get_plugin_version() -> String:
	return "4.0"

func get_window_reference():
	return main_window

func get_panel_reference():
	return dock_panel

# Handle potential errors gracefully
func _on_error_occurred(error_message: String):
	print("Multi Script Maker: Error occurred - " + error_message)
	# Could implement error recovery logic here if needed

# Handle DPI scaling and screen changes
func _notification(what):
	match what:
		NOTIFICATION_APPLICATION_FOCUS_IN:
			if main_window and is_instance_valid(main_window) and main_window.visible:
				_adjust_window_to_content()
		NOTIFICATION_WM_DPI_CHANGE:
			if main_window and is_instance_valid(main_window):
				call_deferred("_handle_dpi_change")

func _handle_dpi_change():
	if not main_window or not is_instance_valid(main_window):
		return
		
	# Recreate the panel with new DPI settings
	create_dock_panel()
	
	# Adjust window size for new DPI
	_adjust_window_to_content()
