extends Area2D

@export var speed: float = 120.0
@export var patrol_distance: float = 700.0

var start_x: float
var direction: int = 1

func _ready() -> void:
    start_x = position.x
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
    position.x += speed * direction * delta
    if abs(position.x - start_x) > patrol_distance:
        direction *= -1

var overlapping_player: Node2D = null

func _on_body_entered(body: Node2D) -> void:
    if body.name == "Player":
        overlapping_player = body

func _on_body_exited(body: Node2D) -> void:
    if body.name == "Player":
        overlapping_player = null

func _physics_process(_delta: float) -> void:
    if overlapping_player != null:
        # If the player is moving AT ALL while the inspector is touching them...
        if overlapping_player.velocity.length() > 5.0:
            # We use get_parent() to call the punishment function on MainLevel
            if get_parent().has_method("inspector_caught_player"):
                get_parent().inspector_caught_player()
                # Knock the inspector away a bit so it doesn't trigger 60 times a second
                position.x += 100 * direction
