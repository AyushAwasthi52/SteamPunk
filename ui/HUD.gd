extends CanvasLayer

@onready var objective_label: Label = $VBoxContainer/ObjectiveLabel
@onready var prompt_label: Label = $VBoxContainer/PromptLabel
@onready var notification_label: Label = $VBoxContainer/NotificationLabel

func _ready() -> void:
    prompt_label.hide()
    notification_label.text = ""
    objective_label.text = "Objective: Obtain Permit Form 27-B"

func show_prompt(text: String = "Press E to Interact") -> void:
    prompt_label.text = text
    prompt_label.show()

func hide_prompt() -> void:
    prompt_label.hide()

func show_notification(text: String) -> void:
    notification_label.text = text
    # Wait for 4 seconds before clearing the notification
    await get_tree().create_timer(4.0).timeout
    # Only clear it if a newer notification hasn't overwritten it
    if notification_label.text == text:
        notification_label.text = ""
