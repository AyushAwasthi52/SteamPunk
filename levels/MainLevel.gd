extends Node2D

@onready var hud: CanvasLayer = $HUD

var inventory: Array[String] = []
var current_objective: int = 0

# Timer System
var time_left: float = 120.0 # 2 minutes to complete the game! Very stressful.

# Queue System
var serving_number: int = 14
var next_ticket_to_dispense: int = 23
var player_ticket: int = 0
var time_since_last_serve: float = 0.0
var serve_interval: float = 2.0 # Fast queue to make missing it easy
var queue_active: bool = true

func _ready() -> void:
    for child in get_children():
        if child is Area2D and child.has_signal("interacted"):
            child.player_entered_counter.connect(_on_counter_entered)
            child.player_exited_counter.connect(_on_counter_exited)
            child.interacted.connect(_on_counter_interacted)
    update_objective()
    hud.update_queue(serving_number, player_ticket)
    hud.update_timer(time_left)

func _process(delta: float) -> void:
    # Timer
    if time_left > 0:
        time_left -= delta
        if time_left <= 0:
            time_left = 0
            hud.show_notification("The Ministry is now closed. Come back tomorrow.")
            get_tree().paused = true # Stop the game
    hud.update_timer(time_left)
    
    # Queue progression
    if queue_active:
        time_since_last_serve += delta
        if time_since_last_serve >= serve_interval:
            time_since_last_serve = 0.0
            if serving_number < next_ticket_to_dispense:
                serving_number += 1
                hud.update_queue(serving_number, player_ticket)
                # Randomize next interval for annoyance (1.5 to 4.5 seconds)
                serve_interval = randf_range(1.5, 4.5)
                
                if serving_number == player_ticket:
                    hud.show_notification("DING! Number %d is now being served!" % serving_number)
                elif serving_number > player_ticket and player_ticket > 0:
                    hud.show_notification("You missed your turn! Go get a new ticket.")
                    player_ticket = 0
                    hud.update_queue(serving_number, player_ticket)

func update_objective() -> void:
    match current_objective:
        0:
            hud.objective_label.text = "Objective: Take a Number, wait, and get Form 27-B."
        1:
            hud.objective_label.text = "Objective: Get Form 27-B stamped at the Stamp Desk."
        2:
            hud.objective_label.text = "Objective: Submit Stamped Form 27-B to the Permit Registry."
        3:
            hud.objective_label.text = "Objective: You got the permit! But the machine is out of order."

func _on_counter_entered(prompt: String) -> void:
    hud.show_prompt(prompt)

func _on_counter_exited() -> void:
    hud.hide_prompt()

func _on_counter_interacted(counter_id: String) -> void:
    match counter_id:
        "ticket_dispenser":
            if current_objective == 0:
                if player_ticket == 0 or player_ticket < serving_number:
                    player_ticket = next_ticket_to_dispense
                    next_ticket_to_dispense += 1
                    hud.show_notification("You took ticket #%d. Don't step out of line." % player_ticket)
                    hud.update_queue(serving_number, player_ticket)
                else:
                    hud.show_notification("You already have ticket #%d. Wait your turn." % player_ticket)
            else:
                hud.show_notification("You don't need a ticket anymore.")

        "forms_desk":
            if current_objective == 0:
                if player_ticket == 0:
                    hud.show_notification("Take a number from the dispenser first!")
                elif player_ticket > serving_number:
                    hud.show_notification("It's not your turn yet! Now serving %d." % serving_number)
                elif player_ticket < serving_number:
                    hud.show_notification("You missed your turn! Get a new ticket.")
                    player_ticket = 0
                    hud.update_queue(serving_number, player_ticket)
                else:
                    # player_ticket == serving_number
                    inventory.append("form_27b")
                    current_objective = 1
                    hud.show_notification("You slammed down your ticket. Form 27-B acquired.")
                    queue_active = false # Stop queue for now
                    update_objective()
            else:
                hud.show_notification("The clerk ignores you.")

        "stamp_desk":
            if current_objective == 1 and "form_27b" in inventory:
                inventory.erase("form_27b")
                inventory.append("stamped_form_27b")
                current_objective = 2
                hud.show_notification("THUD. Form stamped aggressively.")
                update_objective()
            elif current_objective < 1:
                hud.show_notification("You don't even have the form yet! Next!")
            else:
                hud.show_notification("Already stamped. Move along.")

        "permit_registry":
            if current_objective == 2 and "stamped_form_27b" in inventory:
                inventory.erase("stamped_form_27b")
                inventory.append("permit")
                current_objective = 3
                hud.show_notification("Permit granted. Note: The machine has been broken since 1847.")
                update_objective()
                queue_active = false # Ensure queue stays off
            else:
                hud.show_notification("Incomplete paperwork. Denied.")
