extends CanvasLayer

@onready var objective_label: Label = $VBoxContainer/ObjectiveLabel
@onready var prompt_label: Label = $VBoxContainer/PromptLabel
@onready var notification_label: Label = $VBoxContainer/NotificationLabel
@onready var pressure_label: Label = $VBoxContainer/PressureLabel

@onready var timer_label: Label = $RightPanel/TimerLabel
@onready var queue_label: Label = $RightPanel/QueueLabel
@onready var ticket_label: Label = $RightPanel/TicketLabel

func _ready() -> void:
    prompt_label.hide()
    pressure_label.hide()
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

func update_pressure(pressure: float, stabilized: bool) -> void:
    if not pressure_label.visible:
        pressure_label.show()
    
    if stabilized:
        pressure_label.text = "Boiler Pressure: STABILIZED"
        pressure_label.add_theme_color_override("font_color", Color(0.2, 0.8, 0.2))
    else:
        pressure_label.text = "Boiler Pressure: %d%% (Keep between 80%% and 100%%)" % int(pressure)
        if pressure >= 80.0 and pressure <= 100.0:
            pressure_label.add_theme_color_override("font_color", Color(1.0, 0.8, 0.2)) # Yellow/Good
        else:
            pressure_label.add_theme_color_override("font_color", Color(1.0, 0.4, 0.0)) # Orange/Bad
