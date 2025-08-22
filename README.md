# Multi Script Maker v4.0

![Plugin Banner](https://img.shields.io/badge/Godot-4.0+-blue.svg) ![Version](https://img.shields.io/badge/version-4.0-purple.svg) ![License](https://img.shields.io/badge/license-MIT-green.svg)

A powerful Godot 4 editor plugin that streamlines the creation of multiple GDScript files with advanced folder organization, beautiful UI themes, and intelligent file management.

## ✨ Features

### 🎨 **Beautiful UI with Dual Themes**
- **Purple Theme**: Magical purple gradients with glowing effects and animated particles
- **Black Theme**: Sleek modern dark design with subtle animations
- Smooth theme switching with animated transitions
- Dynamic particle background system that adapts to chosen theme

### 📁 **Advanced Folder Management**
- Create scripts in any project folder structure
- Automatic folder creation for non-existent directories
- Intelligent path normalization and validation
- Visual folder browser integration with EditorFileDialog
- Support for custom folder hierarchies (e.g., `res://scripts/player/controllers/`)

### 🚀 **Streamlined Workflow**
- Create 1-20 scripts simultaneously with a simple interface
- Automatic script template generation with proper class names
- Duplicate file detection and user confirmation
- Step-by-step guided process from naming to folder selection
- Real-time filesystem integration and refresh

### 🎭 **Enhanced User Experience**
- Animated entrance effects for UI elements
- Staggered animations for script entries
- Responsive design that adapts to content
- Intuitive three-stage workflow: Input → Folder Selection → Creation
- Visual feedback for all operations

## 📸 Screenshots

Click on each section to view the screenshots:

<details>
<summary>Plugin Screenshot 1</summary>
<br>
<img width="588" height="588" alt="Plugin Interface 1" src="https://github.com/user-attachments/assets/a61d0424-7548-496c-a861-ad1ba908f2ed">
<p><em>Main Plugin interface</em></p>
</details>

<details>
<summary>Plugin Screenshot 2</summary>
<br>
<img width="588" height="588" alt="Plugin Interface 2" src="https://github.com/user-attachments/assets/8671d578-9fb4-46f9-84fa-e2c59c880484">
<p><em>Settings panel</em></p>
</details>

<details>
<summary>Plugin Screenshot 3</summary>
<br>
<img width="588" height="588" alt="Plugin Interface 3" src="https://github.com/user-attachments/assets/9eb91987-088e-4ec3-a1ba-d97721fd1349">
<p><em>Data visualization</em></p>
</details>

<details>
<summary>Plugin Screenshot 4</summary>
<br>
<img width="588" height="256" alt="Plugin Interface 4" src="https://github.com/user-attachments/assets/b88fccf6-8b6e-4387-9536-16eccbbe93d2">
<p><em>Successfully Message</em></p>
</details>

### Purple Theme Interface
The plugin features a stunning purple theme with magical gradients, glowing borders, and floating particle effects that create an immersive development experience.

### Script Creation Workflow
1. **Input Stage**: Specify number of scripts and enter names
2. **Folder Selection**: Choose target directories for each script
3. **Creation**: Automatic file generation with progress feedback

## 🛠 Installation

1. Download the plugin files
2. Extract to your project's `addons/MSMV4/` directory
3. Enable the plugin in Project Settings → Plugins
4. Look for the "Multi Scripts" button in the Godot toolbar

## 📁 Project Structure

```
addons/MSMV4/
├── plugin.cfg              # Plugin configuration
├── MSMV4.gd                # Main plugin controller
├── multi_script_panel.gd   # UI panel implementation
├── theme_manager.gd        # Theme system and styling
├── script_entry_manager.gd # Script entry handling
└── file_manager.gd         # File operations and folder creation
```

## 🎯 Usage

### Basic Workflow

1. **Launch Plugin**: Click the "Multi Scripts" button in the Godot toolbar
2. **Choose Quantity**: Select how many scripts you want to create (1-20)
3. **Generate Fields**: Click "Generate Script Fields" to create input forms
4. **Enter Names**: Provide names for each script (`.gd` extension added automatically)
5. **Select Folders**: Choose target directories for each script
6. **Create Scripts**: Click "Create All Scripts" to generate files

### Advanced Features

#### Theme Switching
- Toggle between Purple and Black themes using the theme buttons
- Themes persist throughout the session
- Particle effects automatically adapt to the selected theme

#### Folder Management
- Default folder: `res://scripts/`
- Custom folders: Enter any valid project path (e.g., `res://player/systems/`)
- Browse folders: Use the "Browse..." button for visual folder selection
- Automatic creation: Plugin creates missing folders with user confirmation

#### Script Templates
Generated scripts include:
- Proper class name declaration
- Creation timestamp and plugin attribution
- Basic `_ready()` and `_process()` function stubs
- Commented examples for custom functions
- Proper indentation and formatting

## ⚙️ Technical Details

### Architecture
The plugin uses a modular architecture with specialized managers:

- **ThemeManager**: Handles UI theming, animations, and visual effects
- **ScriptEntryManager**: Manages dynamic script entry creation and validation
- **FileManager**: Handles file operations, folder creation, and duplicate detection
- **Main Panel**: Orchestrates the UI workflow and user interactions

### UI Components
- **Panel-based design** with proper anchoring and responsive layout
- **Particle system** with 40+ animated particles for visual appeal
- **Custom StyleBox** implementations for consistent theming
- **Tween animations** for smooth transitions and effects

### File Operations
- **Robust folder creation** with recursive directory support
- **Duplicate detection** with user confirmation dialogs
- **Error handling** for file system operations
- **Automatic filesystem refresh** after operations

## 🎨 Theme System

### Purple Theme Features
- Deep purple background with magical gradients
- Glowing borders and shadow effects
- Animated particles in purple/magenta hues
- Enhanced visual feedback with glow effects

### Black Theme Features
- Modern dark design with subtle contrasts
- Clean lines and minimalist aesthetics
- Monochromatic particle system
- Professional appearance suitable for any workflow

### Customization
The theme system is fully modular and can be extended:
- Color palettes defined in `ThemeManager`
- StyleBox configurations for all UI elements
- Particle color schemes that adapt to themes
- Animation parameters for visual effects

## 🔧 Configuration

### Plugin Settings
```ini
[plugin]
name="Multi Script Maker"
description="Create multiple GDScript files at once with advanced folder organization"
author="Yanel"
version="1.0"
script="MSMV4.gd"
```

### Default Script Template
```gdscript
extends Node
class_name ScriptName

# Script: script_name.gd
# Created with Multi Script Maker Plugin v4.0
# Generated on: [timestamp]

func _ready():
    # Initialize your script here
    pass

func _process(delta):
    # Update logic here
    pass
```

## 🚨 Requirements

- **Godot 4.0** or higher
- **Tool scripts enabled** in project settings
- **File system access** for script creation

## 🐛 Troubleshooting

### Common Issues

**Plugin not appearing in toolbar**
- Ensure plugin is enabled in Project Settings → Plugins
- Check that all files are in the correct `addons/MSMV4/` directory
- Restart Godot after installation

**Folder creation fails**
- Verify project has write permissions
- Check that folder paths are valid Godot resource paths
- Ensure no special characters in folder names

**Scripts not appearing in FileSystem**
- Wait a moment for automatic filesystem refresh
- Manually refresh the FileSystem dock if needed
- Check that scripts were created in the expected locations

### Performance Notes
- Plugin is optimized for up to 20 scripts per batch
- Particle system uses efficient Control nodes for animations
- Memory usage is minimal with proper cleanup on plugin disable

## 🔮 Advanced Usage

### Custom Folder Structures
```
res://scripts/player/          # Player-related scripts
res://scripts/enemies/         # Enemy AI scripts
res://scripts/ui/components/   # UI component scripts
res://scripts/systems/         # Game system scripts
```

### Workflow Integration
- Combine with Godot's scene instantiation for rapid prototyping
- Use generated scripts as starting points for complex systems
- Integrate with version control by organizing scripts in logical folders

## 📋 Changelog

### Version 4.0
- Complete rewrite with modular architecture
- Enhanced UI with dual theme system
- Advanced particle background effects
- Improved folder management with automatic creation
- Better error handling and user feedback
- Responsive design with animated transitions
- Robust duplicate detection system

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

### Development Setup
1. Clone the repository to your `addons/` folder
2. Enable the plugin in Godot
3. Test changes with the toolbar button
4. Follow Godot's coding conventions for GDScript

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**Yanel** - Plugin Developer

## 🙏 Acknowledgments

- Godot Engine community for inspiration and feedback
- Beta testers who provided valuable user experience insights
- Contributors to the theming and animation systems

---

*Transform your Godot development workflow with the power of batch script creation and beautiful, responsive UI design.*
