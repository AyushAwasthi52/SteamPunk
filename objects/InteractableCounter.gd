extends Area2D

signal player_entered_counter(prompt: String)
signal player_exited_counter()
signal interacted(counter_id: String)

@export var counter_id: String = "generic_counter"
@export var prompt_text: String = "Press E to Interact"
@export var counter_color: Color = Color(0.8, 0.5, 0.2, 1.0)

var player_in_range: bool = false

func _ready() -> void:
    if has_node("Sprite2D"):
        $Sprite2D.modulate = counter_color
        
        # Load specific texture based on counter_id
        var tex_path = "res://assets/desk_texture.jpg"
        if counter_id == "ticket_dispenser":
            tex_path = "res://assets/ticket_machine.jpg"
        elif counter_id == "boiler":
            tex_path = "res://assets/boiler.jpg"
        elif counter_id == "shredder":
            tex_path = "res://assets/shredder.jpg"
        elif counter_id == "notary_desk" or counter_id == "call_bell":
            tex_path = "res://assets/notary_desk.jpg"
        elif counter_id == "permit_registry":
            tex_path = "res://assets/registry_desk.jpg"
            
        var tex = load(tex_path)
        if tex:
            $Sprite2D.texture = tex
            
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
    if body.name == "Player":
        player_in_range = true
        player_entered_counter.emit(prompt_text)

func _on_body_exited(body: Node2D) -> void:
    if body.name == "Player":
        player_in_range = false
        player_exited_counter.emit()

func _process(_delta: float) -> void:
    if player_in_range and Input.is_action_just_pressed("interact"):
        interacted.emit(counter_id)
