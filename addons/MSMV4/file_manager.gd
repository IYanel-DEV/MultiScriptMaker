@tool
extends RefCounted
class_name FileManager

var plugin_ref
var main_panel  # Reference to main panel for dialogs

func setup_plugin_reference(plugin):
	plugin_ref = plugin

func setup_main_panel_reference(panel):
	main_panel = panel

func check_for_duplicate_scripts(script_entries: Array) -> Dictionary:
	var duplicates = []
	var has_duplicates = false
	
	for entry in script_entries:
		var script_name = entry.name_input.text.strip_edges()
		
		if script_name.is_empty():
			continue
			
		if not script_name.ends_with(".gd"):
			script_name += ".gd"
		
		var target_folder = "res://scripts"  # default
		if entry.has("folder_input") and entry.folder_input != null:
			target_folder = entry.folder_input.text.strip_edges()
			if target_folder.is_empty():
				target_folder = "res://scripts"
		
		var file_path = target_folder + "/" + script_name
		
		if FileAccess.file_exists(file_path):
			duplicates.append({
				"script_name": script_name,
				"folder": target_folder,
				"full_path": file_path
			})
			has_duplicates = true
	
	return {
		"has_duplicates": has_duplicates,
		"duplicate_list": duplicates
	}

func create_scripts_with_folders(script_entries: Array) -> int:
	var created_count = 0
	var folders_to_create = []
	var folder_creation_needed = false
	
	print("FileManager: Starting script creation process...")
	
	# First pass: check which folders need to be created
	for entry in script_entries:
		var script_name = entry.name_input.text.strip_edges()
		
		if script_name.is_empty():
			continue
		
		var target_folder = "res://scripts"  # default
		if entry.has("folder_input") and entry.folder_input != null:
			target_folder = entry.folder_input.text.strip_edges()
			if target_folder.is_empty():
				target_folder = "res://scripts"
		
		# Normalize the path
		target_folder = normalize_path(target_folder)
		print("FileManager: Checking folder existence: " + target_folder)
		
		if not DirAccess.dir_exists_absolute(target_folder):
			if not target_folder in folders_to_create:
				folders_to_create.append(target_folder)
				folder_creation_needed = true
				print("FileManager: Folder needs to be created: " + target_folder)
	
	# If folders need to be created, ask user and create them
	if folder_creation_needed:
		print("FileManager: Need to create " + str(folders_to_create.size()) + " folders")
		var should_create = await ask_create_folders(folders_to_create)
		if not should_create:
			print("FileManager: User cancelled folder creation")
			return 0  # User cancelled
		
		print("FileManager: User confirmed folder creation, proceeding...")
		
		# Create the folders that don't exist - IMPROVED VERSION
		var created_folders = []
		for folder_path in folders_to_create:
			print("FileManager: Attempting to create folder: " + folder_path)
			var creation_result = await create_folder_fast(folder_path)
			if not creation_result:
				var error_msg = "Failed to create folder: " + folder_path
				print("FileManager: ERROR - " + error_msg)
				if main_panel:
					main_panel.show_message(error_msg)
				return 0
			else:
				print("FileManager: Successfully created folder: " + folder_path)
				created_folders.append(folder_path)
		
		# Show success message for folder creation
		if created_folders.size() > 0:
			var folders_text = ""
			for folder in created_folders:
				folders_text += "• " + folder + "\n"
			var success_msg = "Successfully created " + str(created_folders.size()) + " folder(s):\n" + folders_text
			if main_panel:
				main_panel.show_success_message(success_msg)
			
			# Refresh filesystem immediately after folder creation
			if plugin_ref:
				plugin_ref.refresh_filesystem()
				# Small delay to let filesystem update
				await get_tree().create_timer(0.2).timeout
	else:
		print("FileManager: All required folders already exist")
	
	# Second pass: actually create the scripts
	print("FileManager: Starting script creation...")
	for entry in script_entries:
		var script_name = entry.name_input.text.strip_edges()
		
		if script_name.is_empty():
			continue
			
		if not script_name.ends_with(".gd"):
			script_name += ".gd"
		
		var target_folder = "res://scripts"  # default
		if entry.has("folder_input") and entry.folder_input != null:
			target_folder = entry.folder_input.text.strip_edges()
			if target_folder.is_empty():
				target_folder = "res://scripts"
		
		# Normalize the path
		target_folder = normalize_path(target_folder)
		
		# Skip if file already exists (duplicate checking was done earlier)
		var file_path = target_folder + "/" + script_name
		if FileAccess.file_exists(file_path):
			print("FileManager: Skipping existing file: " + file_path)
			continue
		
		print("FileManager: Creating script: " + script_name + " in " + target_folder)
		if await  create_script_file(script_name, target_folder):
			created_count += 1
			print("FileManager: Successfully created script: " + file_path)
		else:
			print("FileManager: Failed to create script: " + script_name + " in " + target_folder)
	
	print("FileManager: Script creation completed. Created " + str(created_count) + " scripts")
	return created_count

func normalize_path(path: String) -> String:
	# Ensure path starts with res:// and remove any trailing slashes
	if not path.begins_with("res://"):
		if path.begins_with("/"):
			path = "res:/" + path
		else:
			path = "res://" + path
	
	# Remove trailing slash
	if path.ends_with("/") and path != "res://":
		path = path.substr(0, path.length() - 1)
	
	return path

# In file_manager.gd, replace the create_folder_step_by_step function with this:
func create_folder_step_by_step(folder_path: String) -> bool:
	print("FileManager: Step-by-step folder creation for: " + folder_path)
	
	# Remove 'res://' prefix
	var path = folder_path.replace("res://", "")
	var parts = path.split("/")
	var current_path = "res://"
	
	for part in parts:
		if part.is_empty():
			continue
			
		current_path += part + "/"
		
		if not DirAccess.dir_exists_absolute(current_path):
			var dir = DirAccess.open("res://")
			if dir == null:
				print("FileManager: Failed to open res:// directory")
				return false
			
			# Create the relative path from res://
			var relative_path = current_path.replace("res://", "")
			if relative_path.ends_with("/"):
				relative_path = relative_path.substr(0, relative_path.length() - 1)
			
			var result = dir.make_dir(relative_path)
			if result != OK:
				print("FileManager: Failed to create directory: " + current_path + " (Error: " + str(result) + ")")
				return false
			print("FileManager: Created directory: " + current_path)
	
	print("FileManager: Successfully created all directories step-by-step")
	return true
func create_folder_fast(folder_path: String) -> bool:
	print("FileManager: Fast folder creation for: " + folder_path)
	folder_path = normalize_path(folder_path)
	print("FileManager: Normalized path: " + folder_path)

	if DirAccess.dir_exists_absolute(folder_path):
		print("FileManager: Folder already exists: " + folder_path)
		return true

	# Try multiple approaches to create the folder
	var success = false
	
	# Approach 1: Use make_dir_recursive
	var dir := DirAccess.open("res://")
	if dir != null:
		# Remove 'res://' prefix for relative path
		var relative_path = folder_path.replace("res://", "")
		
		# Create directory recursively
		var result = dir.make_dir_recursive(relative_path)
		if result == OK:
			print("FileManager: Successfully created directory with make_dir_recursive: " + folder_path)
			success = true
	
	# Approach 2: If first approach failed, try step-by-step creation
	if not success:
		print("FileManager: make_dir_recursive failed, trying step-by-step creation...")
		success = create_folder_step_by_step(folder_path)
	
	# Refresh filesystem if successful
	if success and plugin_ref:
		plugin_ref.refresh_filesystem()
		# Give the filesystem a moment to update
		await get_tree().create_timer(0.1).timeout
	
	return success
func create_script_file(script_name: String, folder_path: String) -> bool:
	print("FileManager: Creating script file: " + script_name + " in " + folder_path)
	
	# Normalize the folder path
	folder_path = normalize_path(folder_path)
	
	# Ensure folder exists (should be created already, but double-check)
	if not DirAccess.dir_exists_absolute(folder_path):
		print("FileManager: Folder doesn't exist, attempting to create: " + folder_path)
		if not await create_folder_fast(folder_path):
			print("FileManager: Failed to create folder structure")
			return false
	
	var file_path = folder_path + "/" + script_name
	
	# Check if file already exists
	if FileAccess.file_exists(file_path):
		print("FileManager: File already exists: " + file_path)
		return false
	
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	
	if file == null:
		print("FileManager: Failed to create file: " + file_path)
		var error = FileAccess.get_open_error()
		print("FileManager: File access error: " + str(error))
		return false
	
	# Write script template
	var script_content = generate_script_template(script_name)
	file.store_string(script_content)
	file.close()
	
	print("FileManager: Successfully created script: " + file_path)
	return true

func ask_create_folders(folders: Array) -> bool:
	if not main_panel:
		print("FileManager: Main panel reference not set, defaulting to create folders")
		return true
	
	print("FileManager: Showing folder creation dialog for " + str(folders.size()) + " folders")
	
	var dialog = ConfirmationDialog.new()
	dialog.title = "Create Missing Folders?"
	
	var folder_list = ""
	for folder in folders:
		folder_list += "• " + folder + "\n"
	
	dialog.dialog_text = "The following folders don't exist and will be created automatically:\n\n" + folder_list + "\nDo you want to continue?"
	dialog.min_size = Vector2i(500, 300)
	
	main_panel.add_child(dialog)
	dialog.popup_centered()
	
	# Use a simpler approach - create a custom signal and wait for it
	var response_received = false
	var user_choice = false
	
	# Store references in the dialog itself
	dialog.set_meta("response_received", response_received)
	dialog.set_meta("user_choice", user_choice)
	
	# Connect signals using method references instead of lambdas
	dialog.confirmed.connect(_on_folder_dialog_confirmed.bind(dialog))
	dialog.canceled.connect(_on_folder_dialog_canceled.bind(dialog))
	
	# Wait for response
	while not dialog.get_meta("response_received"):
		await get_tree().process_frame
	
	user_choice = dialog.get_meta("user_choice")
	dialog.queue_free()
	
	print("FileManager: User response: " + str(user_choice))
	return user_choice

# Helper function for confirmed signal
func _on_folder_dialog_confirmed(dialog: ConfirmationDialog):
	dialog.set_meta("response_received", true)
	dialog.set_meta("user_choice", true)

# Helper function for canceled signal
func _on_folder_dialog_canceled(dialog: ConfirmationDialog):
	dialog.set_meta("response_received", true)
	dialog.set_meta("user_choice", false)
func generate_script_template(script_name: String) -> String:
	var script_class_name = script_name.get_basename()
	
	# Make sure class name starts with uppercase and is valid
	if script_class_name.length() > 0:
		script_class_name = script_class_name[0].to_upper() + script_class_name.substr(1)
		# Remove any invalid characters for class names
		script_class_name = script_class_name.replace(" ", "").replace("-", "_")
	
	var template = "extends Node\n"
	template += "class_name " + script_class_name + "\n\n"
	template += "# Script: " + script_name + "\n"
	template += "# Created with Multi Script Maker Plugin v4.0\n"
	template += "# Generated on: " + Time.get_datetime_string_from_system() + "\n\n"
	template += "# Called when the node enters the scene tree for the first time\n"
	template += "func _ready():\n"
	template += "\t# Initialize your script here\n"
	template += "\tpass\n\n"
	template += "# Called every frame. 'delta' is the elapsed time since the previous frame\n"
	template += "func _process(delta):\n"
	template += "\t# Update logic here\n"
	template += "\tpass\n\n"
	template += "# Add your custom functions below\n"
	template += "# Example:\n"
	template += "# func custom_function():\n"
	template += "#\tprint(\"Hello from " + script_class_name + "!\")\n"
	
	return template

func refresh_filesystem():
	if plugin_ref:
		plugin_ref.refresh_filesystem()
		print("FileManager: Filesystem refreshed")
	else:
		print("FileManager: Plugin reference not available for filesystem refresh")

func get_tree():
	if main_panel and is_instance_valid(main_panel):
		return main_panel.get_tree()
	elif plugin_ref and is_instance_valid(plugin_ref):
		return plugin_ref.get_tree()
	return null
