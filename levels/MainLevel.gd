extends Node2D

@onready var hud: CanvasLayer = $HUD
@onready var interactable_counter: Area2D = $InteractableCounter

func _ready() -> void:
    interactable_counter.body_entered.connect(_on_counter_body_entered)
    interactable_counter.body_exited.connect(_on_counter_body_exited)
    interactable_counter.interacted.connect(_on_counter_interacted)

func _on_counter_body_entered(body: Node2D) -> void:
    if body.name == "Player":
        hud.show_prompt("Press E to request Permit Form 27-B")

func _on_counter_body_exited(body: Node2D) -> void:
    if body.name == "Player":
        hud.hide_prompt()

func _on_counter_interacted() -> void:
    hud.show_notification("The clerk ignores you for 3 minutes, then hands you Form 27-B.")
