@tool
extends RefCounted
class_name ThemeManager

# Enhanced Theme colors with beautiful gradients and effects
var PURPLE_THEME = {
	"primary": Color(0.45, 0.25, 0.85, 1.0),
	"secondary": Color(0.35, 0.15, 0.65, 1.0),
	"accent": Color(0.65, 0.45, 1.0, 1.0),
	"background": Color(0.06, 0.03, 0.12, 1.0),  # Deep purple background
	"surface": Color(0.12, 0.06, 0.22, 1.0),     # Rich purple surface
	"surface_variant": Color(0.16, 0.08, 0.28, 1.0),  # Lighter surface
	"text": Color(0.96, 0.96, 1.0, 1.0),
	"text_secondary": Color(0.82, 0.82, 0.92, 1.0),
	"button_hover": Color(0.55, 0.35, 0.95, 1.0),
	"button_pressed": Color(0.25, 0.12, 0.55, 1.0),
	"border": Color(0.65, 0.45, 1.0, 0.7),
	"border_bright": Color(0.8, 0.6, 1.0, 0.9),
	"glow": Color(0.65, 0.45, 1.0, 0.4),  # For glowing effects
	"shadow": Color(0.2, 0.1, 0.4, 0.6)
}

var BLACK_THEME = {
	"primary": Color(0.28, 0.28, 0.28, 1.0),
	"secondary": Color(0.18, 0.18, 0.18, 1.0),
	"accent": Color(0.5, 0.5, 0.5, 1.0),
	"background": Color(0.05, 0.05, 0.05, 1.0),
	"surface": Color(0.15, 0.15, 0.15, 1.0),
	"surface_variant": Color(0.22, 0.22, 0.22, 1.0),
	"text": Color(0.96, 0.96, 0.96, 1.0),
	"text_secondary": Color(0.82, 0.82, 0.82, 1.0),
	"button_hover": Color(0.38, 0.38, 0.38, 1.0),
	"button_pressed": Color(0.12, 0.12, 0.12, 1.0),
	"border": Color(0.5, 0.5, 0.5, 0.7),
	"border_bright": Color(0.7, 0.7, 0.7, 0.9),
	"glow": Color(0.5, 0.5, 0.5, 0.3),
	"shadow": Color(0.02, 0.02, 0.02, 0.8)
}

var current_theme = "purple"

func get_current_theme_colors():
	return PURPLE_THEME if current_theme == "purple" else BLACK_THEME

func apply_theme_to_panel(panel: Control, purple_btn: Button, black_btn: Button, create_btn: Button):
	var theme_colors = get_current_theme_colors()
	
	# Create beautiful panel background with gradient effect
	var main_style = StyleBoxFlat.new()
	main_style.bg_color = theme_colors.background
	
	# Enhanced styling based on theme
	if current_theme == "purple":
		# Purple theme with magical effects
		main_style.corner_radius_top_left = 20
		main_style.corner_radius_top_right = 20
		main_style.corner_radius_bottom_left = 20
		main_style.corner_radius_bottom_right = 20
		main_style.border_color = theme_colors.border_bright
		main_style.border_width_left = 3
		main_style.border_width_right = 3
		main_style.border_width_top = 3
		main_style.border_width_bottom = 3
		# Beautiful shadow effect
		main_style.shadow_color = theme_colors.shadow
		main_style.shadow_size = 12
		main_style.shadow_offset = Vector2(0, 6)
		# Add subtle inner glow
		main_style.expand_margin_left = 2
		main_style.expand_margin_right = 2
		main_style.expand_margin_top = 2
		main_style.expand_margin_bottom = 2
	else:
		# Black theme with sleek modern look
		main_style.corner_radius_top_left = 16
		main_style.corner_radius_top_right = 16
		main_style.corner_radius_bottom_left = 16
		main_style.corner_radius_bottom_right = 16
		main_style.border_color = theme_colors.border_bright
		main_style.border_width_left = 2
		main_style.border_width_right = 2
		main_style.border_width_top = 2
		main_style.border_width_bottom = 2
		main_style.shadow_color = theme_colors.shadow
		main_style.shadow_size = 8
		main_style.shadow_offset = Vector2(0, 4)
	
	panel.add_theme_stylebox_override("panel", main_style)
	
	# Apply to theme buttons with enhanced states
	apply_button_theme(purple_btn, theme_colors, current_theme == "purple")
	apply_button_theme(black_btn, theme_colors, current_theme == "black")
	
	# Apply to create button with premium styling
	if create_btn:
		apply_primary_button_theme(create_btn, theme_colors)

func apply_button_theme(button: Button, theme_colors: Dictionary, is_active: bool = false):
	if not button:
		return
		
	# Enhanced normal state
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = theme_colors.surface_variant if is_active else theme_colors.surface
	normal_style.corner_radius_top_left = 10
	normal_style.corner_radius_top_right = 10
	normal_style.corner_radius_bottom_left = 10
	normal_style.corner_radius_bottom_right = 10
	normal_style.border_color = theme_colors.accent if is_active else theme_colors.border
	normal_style.border_width_left = 2
	normal_style.border_width_right = 2
	normal_style.border_width_top = 2
	normal_style.border_width_bottom = 2
	
	# Active button glow effect
	if is_active:
		normal_style.shadow_color = theme_colors.glow
		normal_style.shadow_size = 6
		normal_style.shadow_offset = Vector2(0, 0)
		if current_theme == "purple":
			normal_style.expand_margin_left = 1
			normal_style.expand_margin_right = 1
			normal_style.expand_margin_top = 1
			normal_style.expand_margin_bottom = 1
	
	button.add_theme_stylebox_override("normal", normal_style)
	
	# Premium hover state
	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = theme_colors.button_hover
	hover_style.corner_radius_top_left = 10
	hover_style.corner_radius_top_right = 10
	hover_style.corner_radius_bottom_left = 10
	hover_style.corner_radius_bottom_right = 10
	hover_style.border_color = theme_colors.accent
	hover_style.border_width_left = 3
	hover_style.border_width_right = 3
	hover_style.border_width_top = 3
	hover_style.border_width_bottom = 3
	
	# Enhanced hover glow
	hover_style.shadow_color = theme_colors.glow
	hover_style.shadow_size = 8
	hover_style.shadow_offset = Vector2(0, 0)
	hover_style.expand_margin_left = 2
	hover_style.expand_margin_right = 2
	hover_style.expand_margin_top = 2
	hover_style.expand_margin_bottom = 2
	
	button.add_theme_stylebox_override("hover", hover_style)
	
	# Pressed state with depth
	var pressed_style = StyleBoxFlat.new()
	pressed_style.bg_color = theme_colors.button_pressed
	pressed_style.corner_radius_top_left = 10
	pressed_style.corner_radius_top_right = 10
	pressed_style.corner_radius_bottom_left = 10
	pressed_style.corner_radius_bottom_right = 10
	pressed_style.border_color = theme_colors.accent
	pressed_style.border_width_left = 2
	pressed_style.border_width_right = 2
	pressed_style.border_width_top = 2
	pressed_style.border_width_bottom = 2
	# Inward shadow for pressed effect
	pressed_style.content_margin_left = 2
	pressed_style.content_margin_right = 2
	pressed_style.content_margin_top = 2
	pressed_style.content_margin_bottom = 2
	button.add_theme_stylebox_override("pressed", pressed_style)
	
	# Enhanced text colors
	button.add_theme_color_override("font_color", theme_colors.text)
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_pressed_color", theme_colors.text)
	button.add_theme_color_override("font_focus_color", Color.WHITE)

func apply_primary_button_theme(button: Button, theme_colors: Dictionary):
	if not button:
		return
		
	# Premium primary button styling
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = theme_colors.primary
	normal_style.corner_radius_top_left = 12
	normal_style.corner_radius_top_right = 12
	normal_style.corner_radius_bottom_left = 12
	normal_style.corner_radius_bottom_right = 12
	normal_style.border_color = theme_colors.accent
	normal_style.border_width_left = 2
	normal_style.border_width_right = 2
	normal_style.border_width_top = 2
	normal_style.border_width_bottom = 2
	
	# Beautiful shadow and glow
	normal_style.shadow_color = theme_colors.shadow
	normal_style.shadow_size = 8
	normal_style.shadow_offset = Vector2(0, 3)
	
	if current_theme == "purple":
		# Add magical glow for purple theme
		normal_style.expand_margin_left = 3
		normal_style.expand_margin_right = 3
		normal_style.expand_margin_top = 3
		normal_style.expand_margin_bottom = 3
	
	button.add_theme_stylebox_override("normal", normal_style)
	
	# Enhanced hover with stronger effects
	var hover_style = StyleBoxFlat.new()
	hover_style.bg_color = theme_colors.button_hover
	hover_style.corner_radius_top_left = 12
	hover_style.corner_radius_top_right = 12
	hover_style.corner_radius_bottom_left = 12
	hover_style.corner_radius_bottom_right = 12
	hover_style.border_color = theme_colors.border_bright
	hover_style.border_width_left = 3
	hover_style.border_width_right = 3
	hover_style.border_width_top = 3
	hover_style.border_width_bottom = 3
	
	# Stronger glow on hover
	hover_style.shadow_color = theme_colors.glow
	hover_style.shadow_size = 12
	hover_style.shadow_offset = Vector2(0, 0)
	hover_style.expand_margin_left = 4
	hover_style.expand_margin_right = 4
	hover_style.expand_margin_top = 4
	hover_style.expand_margin_bottom = 4
	
	button.add_theme_stylebox_override("hover", hover_style)
	
	# Pressed state with depth
	var pressed_style = StyleBoxFlat.new()
	pressed_style.bg_color = theme_colors.button_pressed
	pressed_style.corner_radius_top_left = 12
	pressed_style.corner_radius_top_right = 12
	pressed_style.corner_radius_bottom_left = 12
	pressed_style.corner_radius_bottom_right = 12
	pressed_style.border_color = theme_colors.accent
	pressed_style.border_width_left = 2
	pressed_style.border_width_right = 2
	pressed_style.border_width_top = 2
	pressed_style.border_width_bottom = 2
	pressed_style.content_margin_left = 3
	pressed_style.content_margin_right = 3
	pressed_style.content_margin_top = 3
	pressed_style.content_margin_bottom = 3
	button.add_theme_stylebox_override("pressed", pressed_style)
	
	# Premium text colors
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_pressed_color", Color.WHITE)
	button.add_theme_color_override("font_focus_color", Color.WHITE)

func apply_theme_to_entry(container: PanelContainer):
	if not container:
		return
		
	var theme_colors = get_current_theme_colors()
	
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = theme_colors.surface
	panel_style.border_color = theme_colors.border
	panel_style.border_width_left = 1
	panel_style.border_width_right = 1
	panel_style.border_width_top = 1
	panel_style.border_width_bottom = 1
	panel_style.corner_radius_top_left = 14
	panel_style.corner_radius_top_right = 14
	panel_style.corner_radius_bottom_left = 14
	panel_style.corner_radius_bottom_right = 14
	
	# Enhanced entry styling
	if current_theme == "purple":
		panel_style.shadow_color = Color(0.2, 0.1, 0.4, 0.4)
		panel_style.shadow_size = 4
		panel_style.shadow_offset = Vector2(0, 2)
		panel_style.expand_margin_left = 1
		panel_style.expand_margin_right = 1
		panel_style.expand_margin_top = 1
		panel_style.expand_margin_bottom = 1
	else:
		panel_style.shadow_color = Color(0.02, 0.02, 0.02, 0.6)
		panel_style.shadow_size = 3
		panel_style.shadow_offset = Vector2(0, 1)
	
	container.add_theme_stylebox_override("panel", panel_style)

func apply_theme_to_entries(entries: Array):
	for entry in entries:
		if entry.has("container") and entry.container != null:
			apply_theme_to_entry(entry.container)

func apply_theme_to_labels(labels: Array):
	var theme_colors = get_current_theme_colors()
	for label in labels:
		if label != null and is_instance_valid(label):
			label.add_theme_color_override("font_color", theme_colors.text)
			# Add subtle text shadow for better readability
			if current_theme == "purple":
				label.add_theme_color_override("font_shadow_color", Color(0.1, 0.05, 0.2, 0.8))
				label.add_theme_constant_override("shadow_offset_x", 1)
				label.add_theme_constant_override("shadow_offset_y", 1)

func apply_theme_to_line_edits(line_edits: Array):
	var theme_colors = get_current_theme_colors()
	
	for line_edit in line_edits:
		if line_edit != null and is_instance_valid(line_edit):
			# Enhanced normal state
			var normal_style = StyleBoxFlat.new()
			normal_style.bg_color = theme_colors.background
			normal_style.border_color = theme_colors.border
			normal_style.border_width_left = 1
			normal_style.border_width_right = 1
			normal_style.border_width_top = 1
			normal_style.border_width_bottom = 1
			normal_style.corner_radius_top_left = 8
			normal_style.corner_radius_top_right = 8
			normal_style.corner_radius_bottom_left = 8
			normal_style.corner_radius_bottom_right = 8
			normal_style.content_margin_left = 8
			normal_style.content_margin_right = 8
			normal_style.content_margin_top = 6
			normal_style.content_margin_bottom = 6
			line_edit.add_theme_stylebox_override("normal", normal_style)
			
			# Beautiful focus state with glow
			var focus_style = StyleBoxFlat.new()
			focus_style.bg_color = theme_colors.surface_variant
			focus_style.border_color = theme_colors.accent
			focus_style.border_width_left = 2
			focus_style.border_width_right = 2
			focus_style.border_width_top = 2
			focus_style.border_width_bottom = 2
			focus_style.corner_radius_top_left = 8
			focus_style.corner_radius_top_right = 8
			focus_style.corner_radius_bottom_left = 8
			focus_style.corner_radius_bottom_right = 8
			focus_style.content_margin_left = 8
			focus_style.content_margin_right = 8
			focus_style.content_margin_top = 6
			focus_style.content_margin_bottom = 6
			
			# Add glow effect for focus
			if current_theme == "purple":
				focus_style.shadow_color = Color(0.6, 0.4, 1.0, 0.5)
				focus_style.shadow_size = 6
				focus_style.shadow_offset = Vector2(0, 0)
				focus_style.expand_margin_left = 2
				focus_style.expand_margin_right = 2
				focus_style.expand_margin_top = 2
				focus_style.expand_margin_bottom = 2
			else:
				focus_style.shadow_color = Color(0.5, 0.5, 0.5, 0.4)
				focus_style.shadow_size = 4
				focus_style.shadow_offset = Vector2(0, 0)
			
			line_edit.add_theme_stylebox_override("focus", focus_style)
			
			# Enhanced text colors
			line_edit.add_theme_color_override("font_color", theme_colors.text)
			line_edit.add_theme_color_override("font_placeholder_color", theme_colors.text_secondary)
			line_edit.add_theme_color_override("font_selected_color", Color.WHITE)
			line_edit.add_theme_color_override("selection_color", theme_colors.accent)
			line_edit.add_theme_color_override("caret_color", theme_colors.accent)

func apply_theme_to_spinbox(spinbox: SpinBox):
	if not spinbox or not is_instance_valid(spinbox):
		return
		
	var theme_colors = get_current_theme_colors()
	
	# Style the spinbox like a line edit
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = theme_colors.surface
	normal_style.border_color = theme_colors.border
	normal_style.border_width_left = 1
	normal_style.border_width_right = 1
	normal_style.border_width_top = 1
	normal_style.border_width_bottom = 1
	normal_style.corner_radius_top_left = 8
	normal_style.corner_radius_top_right = 8
	normal_style.corner_radius_bottom_left = 8
	normal_style.corner_radius_bottom_right = 8
	normal_style.content_margin_left = 8
	normal_style.content_margin_right = 8
	normal_style.content_margin_top = 6
	normal_style.content_margin_bottom = 6
	
	# Apply to the line edit part of spinbox
	var line_edit = spinbox.get_line_edit()
	if line_edit:
		line_edit.add_theme_stylebox_override("normal", normal_style)
		line_edit.add_theme_color_override("font_color", theme_colors.text)

func apply_theme_to_scroll_container(scroll: ScrollContainer):
	if not scroll or not is_instance_valid(scroll):
		return
		
	var theme_colors = get_current_theme_colors()
	
	# Style the scroll container background
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color.TRANSPARENT
	scroll.add_theme_stylebox_override("panel", bg_style)

func apply_separator_theme(separator: HSeparator):
	if not separator or not is_instance_valid(separator):
		return
		
	var theme_colors = get_current_theme_colors()
	
	# Create a subtle separator style
	var sep_style = StyleBoxFlat.new()
	sep_style.bg_color = theme_colors.border
	sep_style.content_margin_top = 1
	sep_style.content_margin_bottom = 1
	separator.add_theme_stylebox_override("separator", sep_style)

# Utility function to create glowing text effect
func add_glow_to_label(label: Label, glow_color: Color = Color.WHITE):
	if not label or not is_instance_valid(label):
		return
		
	label.add_theme_color_override("font_shadow_color", glow_color)
	label.add_theme_constant_override("shadow_offset_x", 0)
	label.add_theme_constant_override("shadow_offset_y", 0)
	label.add_theme_constant_override("shadow_outline_size", 2)

# Create animated theme transition
func create_theme_transition_tween(target_node: Control) -> Tween:
	if not target_node or not is_instance_valid(target_node):
		return null
		
	var tween = target_node.create_tween()
	tween.set_parallel(true)
	return tween

# Apply enhanced styling to dialog
func apply_dialog_theme(dialog: AcceptDialog):
	if not dialog or not is_instance_valid(dialog):
		return
		
	var theme_colors = get_current_theme_colors()
	
	var dialog_style = StyleBoxFlat.new()
	dialog_style.bg_color = theme_colors.surface
	dialog_style.border_color = theme_colors.border_bright
	dialog_style.border_width_left = 2
	dialog_style.border_width_right = 2
	dialog_style.border_width_top = 2
	dialog_style.border_width_bottom = 2
	dialog_style.corner_radius_top_left = 12
	dialog_style.corner_radius_top_right = 12
	dialog_style.corner_radius_bottom_left = 12
	dialog_style.corner_radius_bottom_right = 12
	
	if current_theme == "purple":
		dialog_style.shadow_color = Color(0.2, 0.1, 0.4, 0.7)
		dialog_style.shadow_size = 10
		dialog_style.shadow_offset = Vector2(0, 5)
	else:
		dialog_style.shadow_color = Color(0.02, 0.02, 0.02, 0.8)
		dialog_style.shadow_size = 8
		dialog_style.shadow_offset = Vector2(0, 4)
	
	dialog.add_theme_stylebox_override("panel", dialog_style)

# Get theme-appropriate particle colors
func get_particle_colors() -> Array:
	if current_theme == "purple":
		return [
			Color(0.6, 0.4, 1.0, 0.3),
			Color(0.8, 0.6, 1.0, 0.25),
			Color(0.4, 0.2, 0.9, 0.2),
			Color(0.7, 0.5, 1.0, 0.35),
			Color(0.5, 0.3, 0.8, 0.28)
		]
	else:
		return [
			Color(0.6, 0.6, 0.6, 0.2),
			Color(0.8, 0.8, 0.8, 0.15),
			Color(0.4, 0.4, 0.4, 0.12),
			Color(0.7, 0.7, 0.7, 0.18),
			Color(0.5, 0.5, 0.5, 0.16)
		]
