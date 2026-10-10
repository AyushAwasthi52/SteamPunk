extends Node2D

@onready var hud: CanvasLayer = $HUD

var win_screen_scene = preload("res://ui/WinScreen.tscn")

var inventory: Array[String] = []
var current_objective: int = 0

# Timer System
var time_left: float = 480.0 # 8 minutes

# Queue System
var serving_number: int = 14
var next_ticket_to_dispense: int = 23
var player_ticket: int = 0
var time_since_last_serve: float = 0.0
var serve_interval: float = 2.0
var queue_active: bool = true

# Boiler System
var boiler_pressure: float = 0.0
var boiler_stabilized: bool = false
var boiler_stable_time: float = 0.0

# Notary System
var bell_rings: int = 0
var notary_awake: bool = false

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
    if time_left > 0:
        time_left -= delta
        if time_left <= 0:
            time_left = 0
            hud.show_notification("The Ministry is now closed. Come back tomorrow.")
            get_tree().paused = true
    hud.update_timer(time_left)
    
    if queue_active:
        time_since_last_serve += delta
        if time_since_last_serve >= serve_interval:
            time_since_last_serve = 0.0
            if serving_number < next_ticket_to_dispense:
                serving_number += 1
                hud.update_queue(serving_number, player_ticket)
                serve_interval = randf_range(1.5, 4.5)
                
                if serving_number == player_ticket:
                    hud.show_notification("DING! Number %d is now being served!" % serving_number)
                elif serving_number > player_ticket and player_ticket > 0:
                    hud.show_notification("You missed your turn! Go get a new ticket.")
                    player_ticket = 0
                    hud.update_queue(serving_number, player_ticket)

    if current_objective == 2 and not boiler_stabilized:
        boiler_pressure -= 15.0 * delta
        if boiler_pressure < 0:
            boiler_pressure = 0
        
        if boiler_pressure >= 80.0 and boiler_pressure <= 100.0:
            boiler_stable_time += delta
            if boiler_stable_time >= 3.0:
                boiler_stabilized = true
                hud.show_notification("Boiler Stabilized! Return to the Stamp Desk.")
                current_objective = 3
                update_objective()
        else:
            boiler_stable_time = 0.0
            
        hud.update_pressure(boiler_pressure, boiler_stabilized)

func inspector_caught_player() -> void:
    time_left -= 15.0
    hud.show_notification("INSPECTOR: NO RUNNING! 15 seconds docked!")
    
    if "form_27b" in inventory or "stamped_form_27b" in inventory:
        inventory.clear()
        $Player.is_encumbered = false
        $Player.is_extremely_encumbered = false
        queue_active = true
        current_objective = 0
        update_objective()
        hud.show_notification("INSPECTOR: Contraband paperwork confiscated! Back to the line!")
    elif "form_27b_rev2" in inventory or "stamped_form_27b_rev2" in inventory or "signed_form_27b_rev2" in inventory:
        inventory.clear()
        $Player.is_encumbered = false
        $Player.is_extremely_encumbered = false
        queue_active = true
        current_objective = 5
        update_objective()
        hud.show_notification("INSPECTOR: Contraband paperwork confiscated! Back to the line!")

func update_objective() -> void:
    match current_objective:
        0:
            hud.objective_label.text = "Objective: Take a Number, wait, and get Form 27-B."
        1:
            hud.objective_label.text = "Objective: Get Form 27-B stamped at the Stamp Desk."
        2:
            hud.objective_label.text = "Objective: The stamper is out of pressure! Pump the Boiler."
        3:
            hud.objective_label.text = "Objective: The boiler is fixed. Get the stamp."
        4:
            hud.objective_label.text = "Objective: Form 27-B is obsolete. Go shred it."
        5:
            hud.objective_label.text = "Objective: Take a new ticket and get Form 27-B/Rev2."
        6:
            hud.objective_label.text = "Objective: Get Form 27-B/Rev2 stamped."
        7:
            hud.objective_label.text = "Objective: Submit Stamped Form to the Permit Registry."
        8:
            hud.objective_label.text = "Objective: Form rejected! You need a Notary Signature."
        9:
            hud.objective_label.text = "Objective: The Notary is asleep. Ring the bell 20 times!"
        10:
            hud.objective_label.text = "Objective: The Notary needs a Blue Ink Pen from the Supply Closet."
        11:
            hud.objective_label.text = "Objective: Drag the 200lb Ink Pen back to the Notary."
        12:
            hud.objective_label.text = "Objective: Take Signed Form to the Permit Registry (For Real)."
        13:
            hud.objective_label.text = "Objective: You got the permit! But the machine is out of order."

func _on_counter_entered(prompt: String) -> void:
    hud.show_prompt(prompt)

func _on_counter_exited() -> void:
    hud.hide_prompt()

func _on_counter_interacted(counter_id: String) -> void:
    match counter_id:
        "ticket_dispenser":
            if current_objective == 0 or current_objective == 5:
                if player_ticket == 0 or player_ticket < serving_number:
                    if next_ticket_to_dispense <= serving_number:
                        next_ticket_to_dispense = serving_number + 5
                        
                    player_ticket = next_ticket_to_dispense
                    next_ticket_to_dispense += 1
                    hud.show_notification("You took ticket #%d. Don't step out of line." % player_ticket)
                    hud.update_queue(serving_number, player_ticket)
                else:
                    hud.show_notification("You already have ticket #%d. Wait your turn." % player_ticket)
            else:
                hud.show_notification("You don't need a ticket anymore.")

        "forms_desk":
            if current_objective == 0 or current_objective == 5:
                if player_ticket == 0:
                    hud.show_notification("Take a number from the dispenser first!")
                elif player_ticket > serving_number:
                    hud.show_notification("It's not your turn yet! Now serving %d." % serving_number)
                elif player_ticket < serving_number:
                    hud.show_notification("You missed your turn! Get a new ticket.")
                    player_ticket = 0
                    hud.update_queue(serving_number, player_ticket)
                else:
                    if current_objective == 0:
                        inventory.append("form_27b")
                        current_objective = 1
                        $Player.is_encumbered = true
                        hud.show_notification("Form 27-B acquired. It is printed on an 80lb slab of lead.")
                    else:
                        inventory.append("form_27b_rev2")
                        current_objective = 6
                        $Player.is_encumbered = true
                        hud.show_notification("Form 27-B/Rev2 acquired. This one is printed on depleted uranium.")
                    queue_active = false
                    update_objective()
            else:
                hud.show_notification("The clerk ignores you.")

        "stamp_desk":
            if current_objective == 1 and "form_27b" in inventory:
                hud.show_notification("Clerk: 'Pneumatic stamper has no pressure. Go pump the boiler.'")
                current_objective = 2
                update_objective()
            elif current_objective == 3 and "form_27b" in inventory:
                hud.show_notification("Clerk: 'Form 27-B was obsoleted at noon. Go shred it and get Rev2.'")
                current_objective = 4
                queue_active = true
                update_objective()
            elif current_objective == 6 and "form_27b_rev2" in inventory:
                inventory.erase("form_27b_rev2")
                inventory.append("stamped_form_27b_rev2")
                current_objective = 7
                hud.show_notification("THUD. Form stamped aggressively. It's still heavy.")
                update_objective()
            elif current_objective < 1:
                hud.show_notification("You don't even have the form yet! Next!")
            elif current_objective == 2:
                hud.show_notification("Clerk: 'The boiler is still broken!'")
            else:
                hud.show_notification("Already stamped. Move along.")
                
        "boiler":
            if current_objective == 2 and not boiler_stabilized:
                boiler_pressure += 5.0
                if boiler_pressure > 110.0:
                    boiler_pressure = 110.0
            elif boiler_stabilized:
                hud.show_notification("The boiler is already stable.")
            else:
                hud.show_notification("You shouldn't touch that unless authorized.")
                
        "shredder":
            if current_objective == 4 and "form_27b" in inventory:
                inventory.erase("form_27b")
                current_objective = 5
                $Player.is_encumbered = false
                hud.show_notification("Form shredded. You feel physically lighter, but spiritually heavier.")
                update_objective()
            else:
                hud.show_notification("You have nothing that needs shredding right now.")

        "permit_registry":
            if current_objective == 7 and "stamped_form_27b_rev2" in inventory:
                hud.show_notification("Registry Clerk: 'Missing Notary Signature. Go to the Notary.'")
                current_objective = 8
                update_objective()
            elif current_objective == 12 and "signed_form_27b_rev2" in inventory:
                inventory.erase("signed_form_27b_rev2")
                inventory.append("permit")
                current_objective = 13
                $Player.is_encumbered = false
                $Player.is_extremely_encumbered = false
                hud.show_notification("Permit granted. Note: The machine has been broken since 1847.")
                update_objective()
                queue_active = false
                show_win_screen()
            else:
                hud.show_notification("Incomplete paperwork. Denied.")
                
        "notary_desk":
            if current_objective == 8:
                hud.show_notification("Notary: 'Zzz...' (They are asleep)")
                current_objective = 9
                update_objective()
            elif current_objective == 9:
                if notary_awake:
                    hud.show_notification("Notary: 'My pen is out of ink. Go get the Blue Ink from Supply Closet.'")
                    current_objective = 10
                    update_objective()
                else:
                    hud.show_notification("Notary: 'Zzz...' (Use the Call Bell to wake them)")
            elif current_objective == 11 and "blue_ink_pen" in inventory:
                inventory.erase("blue_ink_pen")
                inventory.erase("stamped_form_27b_rev2")
                inventory.append("signed_form_27b_rev2")
                current_objective = 12
                $Player.is_extremely_encumbered = false
                hud.show_notification("Notary: *Scribble* Done. Take it away.")
                update_objective()
            else:
                hud.show_notification("The Notary ignores you.")
                
        "call_bell":
            if current_objective == 9 and not notary_awake:
                bell_rings += 1
                if bell_rings >= 20:
                    notary_awake = true
                    hud.show_notification("Notary: 'AH! I'm awake! What do you want?!'")
                else:
                    hud.show_notification("*DING* (Rung %d/20 times)" % bell_rings)
            else:
                hud.show_notification("Please do not ring the bell unnecessarily.")
                
        "supply_closet":
            if current_objective == 10:
                inventory.append("blue_ink_pen")
                current_objective = 11
                $Player.is_extremely_encumbered = true
                hud.show_notification("You found the Blue Ink Pen. It is a 200lb cast-iron ink barrel.")
                update_objective()
            else:
                hud.show_notification("The closet is locked.")

func show_win_screen() -> void:
    var win_screen = win_screen_scene.instantiate()
    add_child(win_screen)
    get_tree().paused = true
