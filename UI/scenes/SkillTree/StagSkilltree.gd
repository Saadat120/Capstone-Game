class_name stagSkillTree extends Control

@onready var skill_one_details: PanelContainer = $SkillOneDetails
@onready var tree_one_details_1: PanelContainer = $TreeOneDetails1
@onready var tree_one_details_2: PanelContainer = $TreeOneDetails2
@onready var tree_two_details_1: PanelContainer = $TreeTwoDetails1
@onready var tree_two_details_2: PanelContainer = $TreeTwoDetails2

func _ready() -> void:
	skill_one_details.hide()
	tree_one_details_1.hide()
	tree_one_details_2.hide()
	tree_two_details_1.hide()
	tree_two_details_2.hide()

func _on_base_skill_mouse_entered() -> void:
	skill_one_details.show()


func _on_base_skill_mouse_exited() -> void:
	skill_one_details.hide()

func _on_skill_tree_one_mouse_entered() -> void:
	tree_one_details_1.show()

func _on_skill_tree_one_mouse_exited() -> void:
	tree_one_details_1.hide()

func _on_skill_button_mouse_entered() -> void:
	tree_one_details_2.show()

func _on_skill_button_mouse_exited() -> void:
	tree_one_details_2.hide()

func _on_skill_button_2_mouse_entered() -> void:
	tree_two_details_1.show()

func _on_skill_button_2_mouse_exited() -> void:
	tree_two_details_1.hide()

func _on_skill_button_t_2_mouse_entered() -> void:
	tree_two_details_2.show()

func _on_skill_button_t_2_mouse_exited() -> void:
	tree_two_details_2.hide()
