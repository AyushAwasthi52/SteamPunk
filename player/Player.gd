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

func _ready() -> void:
    # Shuffle right at the start to immediately confuse them
    control_map.shuffle()

func _physics_process(delta: float) -> void:
    # Scramble logic
    current_timer += delta
    if current_timer >= scramble_interval:
        current_timer = 0.0
        control_map.shuffle()
        $ColorRect.color = Color(1, 0, 0)
        await get_tree().create_timer(0.2).timeout
        $ColorRect.color = Color(0.2, 0.6, 0.8)

    var left = control_map[0]
    var right = control_map[1]
    var up = control_map[2]
    var down = control_map[3]
    
    var direction := Vector2.ZERO
    direction.x = Input.get_action_strength(right) - Input.get_action_strength(left)
    direction.y = Input.get_action_strength(down) - Input.get_action_strength(up)
    
    if direction.length() > 1.0:
        direction = direction.normalized()
    
    var current_speed = base_speed
    if is_extremely_encumbered:
        current_speed = extremely_encumbered_speed
    elif is_encumbered:
        current_speed = encumbered_speed
        
    velocity = direction * current_speed
    move_and_slide()
