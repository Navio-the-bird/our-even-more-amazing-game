extends Node
## Centralized Global Manager to control the Input Map
## 
## Can be used to disable any input globally

## The array containing the names of disabled actions. Actions whose names are in this
## array are considered as handled as soon as pressed and are ignored.
var disabled_actions: PackedStringArray = PackedStringArray()

## The array containing the names of actions related to the player character.
var player_actions: PackedStringArray = [
	"move_left",
	"move_right",
	"move_up",
	"move_down",
	"jump",
	"ability_1",
	"ability_2",
]

func _input(event: InputEvent) -> void:
	for action in disabled_actions:
		if event.is_action(action):
			get_viewport().set_input_as_handled()
			return

## Add the action name to [member disabled_actions]
func disable_action(action: String) -> void:
	if not action in disabled_actions:
		disabled_actions.append(action)

## Add the action names to [member disabled_actions]
func enable_action(action: String) -> void:
	if action in disabled_actions:
		disabled_actions.erase(action)

## Remove the action name from [member disabled_actions]
func disable_action_group(group: PackedStringArray) -> void:
	for action in group:
		if not action in disabled_actions:
			disabled_actions.append(action)

## Remove the action names from [member disabled_actions]
func enable_action_group(group: PackedStringArray) -> void:
	for action in group:
		if action in disabled_actions:
			disabled_actions.erase(action)
