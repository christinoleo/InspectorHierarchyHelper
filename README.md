# Script for fast folder-like structure in Editor

Ever wanted to have a nice structure in the editor inspector? Are your exported variables unorganized? Not willing to override \_get, \_set and \_get_property_list and set up all the necessary things? Here is a simple helper class to create structure from code!!

![showcase](/screenshot.png?raw=true "Example of folder-like structure")

## Install

You can just copy-paste the file [addons/inspector_hierarchy_helper/InspectorHierarchyHelper.gd](/addons/inspector_hierarchy_helper/InspectorHierarchyHelper.gd) to your project, or clone/download this repo into your project. No need to activate the plugin. This is merely a helper script.

## Example

See the example folder for a more comprehensive example.

If your code is something like:

```gdscript
extends Node

# public
export var my_number := 1
export(NodePath) var some_node
# ...

# private
var another_var := 5.0
```

You need to:

- Restructure the code so that private variables start with \_
- Public vars _always_ need a specified type
- Make your script of type tool (adding the _tool_ keyword in the beginning)
- Include the startup code
- Include `__` in the middle of variable names whenever you want a folder

like so:

```gdscript
tool
extends Node

# public
var my_number := 1
var some_node: NodePath
var my_folder__inner_variable_1 := 1.0
var my_folder__inner_variable_2 := "YES I HAVE A FOLDER"
var some_other_folder__inner_variable_1 := 2.0
var some_other_folder__inner_variable_2 := "YES I HAVE ANOTHER FOLDER"
# ...

# private
var _another_var := 5.0

# Startup Code
var _help: InspectorHierarchyHelper
func _init() -> void: _help = InspectorHierarchyHelper.new(self)
func _get(property): return _help._get(property)
func _set(property, value): return _help._set(property, value)
func _get_property_list(): return _help._get_property_list()

```

And voilá, you are all setup!

## Limitations

Once again, this has a simple-usecase mindset. For further customization, you can set the `hint` and `hint_string` of the variables as is in the example folder, but hiding and showing variables depending on other variables is not supported (PRs welcome, though!).
Also, there are several limitations of \_get_property_list. For example, the inspector loses what is the default variable, custom Resources are not yet supported and it is weird to sync exported variables with the ones from \_get_property_list, so if you set this script up in one of your nodes, prefer to use only it rather than the export patten in that script (I suggest only to use this script in the nodes you want the folder structure, but the others just stick to the export pattern).

## Note that now you have a tool script

Use `Engine.editor_hint` for your advantage, so that you only run the logic you need in the editor vs in your game!
