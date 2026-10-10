extends CharacterBody2D

@export var base_speed: float = 250.0
@export var encumbered_speed: float = 45.0
@export var extremely_encumbered_speed: float = 20.0
var is_encumbered: bool = false
var is_extremely_encumbered: bool = false

# Gloriously Awful UX: Control Scrambler
var control_map: Array[String] = ["move_left", "move_right", "move_up", "move_down"]
var scramble_interval: float = 12.0
var current_timer: float = 0.0

var dev_mode: bool = false

func _ready() -> void:
    # Shuffle right at the start to immediately confuse them
    control_map.shuffle()

var cheat_buffer: String = ""
var cheat_code: String = "bribe"

func _unhandled_key_input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo:
        var key_str = OS.get_keycode_string(event.physical_keycode).to_lower()
        if key_str.length() == 1:
            cheat_buffer += key_str
            if cheat_buffer.length() > 10:
                cheat_buffer = cheat_buffer.substr(cheat_buffer.length() - 10)
            if cheat_buffer.ends_with(cheat_code):
                dev_mode = !dev_mode
                var msg = "Cheat Code Activated: Bribe accepted. Mechanics bypassed." if dev_mode else "Cheat Code Deactivated: Bribe funds dried up."
                if get_parent() and get_parent().has_node("HUD"):
                    get_parent().get_node("HUD").show_notification(msg)

func _physics_process(delta: float) -> void:

    # Scramble logic (skipped in dev mode)
    if not dev_mode:
        current_timer += delta
        if current_timer >= scramble_interval:
            current_timer = 0.0
            control_map.shuffle()
            $Sprite2D.modulate = Color(1, 0, 0)
            await get_tree().create_timer(0.2).timeout
            $Sprite2D.modulate = Color(1, 1, 1)

    var left = "move_left" if dev_mode else control_map[0]
    var right = "move_right" if dev_mode else control_map[1]
    var up = "move_up" if dev_mode else control_map[2]
    var down = "move_down" if dev_mode else control_map[3]
    
    var direction := Vector2.ZERO
    direction.x = Input.get_action_strength(right) - Input.get_action_strength(left)
    direction.y = Input.get_action_strength(down) - Input.get_action_strength(up)
    
    if direction.length() > 1.0:
        direction = direction.normalized()
    
    var current_speed = base_speed
    if not dev_mode:
        if is_extremely_encumbered:
            current_speed = extremely_encumbered_speed
        elif is_encumbered:
            current_speed = encumbered_speed
        
    velocity = direction * current_speed
    move_and_slide()
