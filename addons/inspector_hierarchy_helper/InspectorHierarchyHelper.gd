tool
extends Reference
class_name InspectorHierarchyHelper

var _node: Node
var all_variables = []
var export_variables = []

var replacement_map = {}

func _init(node: Node, opts:Dictionary = {}) -> void:
	_node = node
	if Engine.editor_hint:
		if node.get_script() != null:
			all_variables = node.get_script().get_script_property_list()
			for v in all_variables:
				if v.usage & PROPERTY_USAGE_SCRIPT_VARIABLE and !v.name.begins_with('_'):
					v.tooltip = 'Generated'
					if v.type == 17:
						v.hint = PROPERTY_HINT_RESOURCE_TYPE
						v.hint_string = v.get('class_name', '')
					if opts.has(v.name):
						for k in opts[v.name].keys():
							v[k] = opts[v.name][k]
					if '__' in v.name:
						var _v = deep_copy(v)
						_v.usage = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_SCRIPT_VARIABLE
						_v.name = v.name.replace('__', '/')
						export_variables.append(_v)
						
						v.usage = PROPERTY_USAGE_STORAGE | PROPERTY_USAGE_NETWORK
						export_variables.append(v)
					else:
						v.usage = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
						export_variables.append(v)
	#			if v.usage & PROPERTY_USAGE_SCRIPT_VARIABLE and '__' in v.name:
	#				v.usage -= PROPERTY_USAGE_SCRIPT_VARIABLE
		

func _get(property):
#	prints('get', property.replace('/', '__'))
	var _property = property
	if '/' in property:
		_property = property.replace('/', '__')
	if _property != property:
		return _node.get(property.replace('/', '__'))

func _set(property, value):
#	prints('set', property.replace('/', '__'), value)
	var _property = property
	if '/' in _property:
		_property = property.replace('/', '__')
	if _property != property:
		_node.set(_property, value)
		_node.property_list_changed_notify()
	
func _get_property_list():
#	print(export_variables)
	return export_variables


static func deep_copy(v):
	var t = typeof(v)

	if t == TYPE_DICTIONARY:
		var d = {}
		for k in v:
			d[k] = deep_copy(v[k])
		return d

	elif t == TYPE_ARRAY:
		var d = []
		d.resize(len(v))
		for i in range(len(v)):
			d[i] = deep_copy(v[i])
		return d

	elif t == TYPE_OBJECT:
		if v.has_method("duplicate"):
			return v.duplicate()
		else:
			print("Error in Copy")
			return v

	else:
		# Other types should be fine,
		# they are value types (except poolarrays maybe)
		return v
