class_name wolfSkillTree extends Control

@onready var base_skill_details: PanelContainer = $BaseSkillDetails
@onready var tree_1_sk_1: PanelContainer = $Tree1Sk1
@onready var tree_1_sk_2: PanelContainer = $Tree1Sk2
@onready var tree_2_sk_1: PanelContainer = $Tree2Sk1
@onready var tree_2_sk_2: PanelContainer = $Tree2Sk2

func _ready() -> void:
	base_skill_details.hide()
	tree_1_sk_1.hide()
	tree_1_sk_2.hide()
	tree_2_sk_1.hide()
	tree_2_sk_2.hide()

func _on_base_skill_mouse_entered() -> void:
	base_skill_details.show()

func _on_base_skill_mouse_exited() -> void:
	base_skill_details.hide()

func _on_sk_tree_1_mouse_entered() -> void:
	tree_1_sk_1.show()

func _on_sk_tree_1_mouse_exited() -> void:
	tree_1_sk_1.hide()

func _on_sk_2_tree_1_mouse_entered() -> void:
	tree_1_sk_2.show()

func _on_sk_2_tree_1_mouse_exited() -> void:
	tree_1_sk_2.hide()

func _on_sk_tree_2_mouse_entered() -> void:
	tree_2_sk_1.show()

func _on_sk_tree_2_mouse_exited() -> void:
	tree_2_sk_1.hide()

func _on_sk_2_tree_2_mouse_entered() -> void:
	tree_2_sk_2.show()

func _on_sk_2_tree_2_mouse_exited() -> void:
	tree_2_sk_2.hide()
