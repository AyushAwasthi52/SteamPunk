extends CanvasLayer

@onready var objective_label: Label = $VBoxContainer/ObjectiveLabel
@onready var prompt_label: Label = $VBoxContainer/PromptLabel
@onready var notification_label: Label = $VBoxContainer/NotificationLabel
@onready var timer_label: Label = $RightPanel/TimerLabel
@onready var queue_label: Label = $RightPanel/QueueLabel
@onready var ticket_label: Label = $RightPanel/TicketLabel

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
    await get_tree().create_timer(4.0).timeout
    if notification_label.text == text:
        notification_label.text = ""

func update_timer(time_left: float) -> void:
    var minutes = int(time_left) / 60
    var seconds = int(time_left) % 60
    timer_label.text = "Ministry Closes: %02d:%02d" % [minutes, seconds]

func update_queue(serving: int, ticket: int) -> void:
    queue_label.text = "Now Serving: %d" % serving
    if ticket > 0:
        ticket_label.text = "Your Ticket: %d" % ticket
    else:
        ticket_label.text = "Your Ticket: None"
