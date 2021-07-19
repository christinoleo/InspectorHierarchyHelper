tool
extends Sprite

var some_var := 1
var some_bool := true 
var myfolder__another_var := 1
var myfolder__another_bool := false
var some_other_folder__one_curve : Curve
var some_other_folder__also_a_texture : Texture
var some_other_folder__some_text := "one"
var some_other_folder__some_path :NodePath
var some_other_folder__some_path2 :String

var _help: InspectorHierarchyHelper

func _ready() -> void:
	prints(some_other_folder__some_path2, some_other_folder__some_text, myfolder__another_bool, myfolder__another_var)

func _init() -> void:
	_help = InspectorHierarchyHelper.new(self,
		{'some_other_folder__some_text': {'hint': PROPERTY_HINT_ENUM, 'hint_string':' one,two,three'},
		'some_other_folder__some_path2': {'hint': PROPERTY_HINT_FILE}
	})


func _get(property): return _help._get(property)  
func _set(property, value): return _help._set(property, value)
func _get_property_list(): return _help._get_property_list()
