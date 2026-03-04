class_name CardUI
extends Control

signal reparent_requested(which_card_ui)

@onready var color: ColorRect = $Color
@onready var state: Label = $State
