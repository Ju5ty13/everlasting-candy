extends Node2D

# Constant reference to player
var player: Player

@onready var anim := $AnimationPlayer  # Reference to AnimationPlayer
@onready var sprite := $Sprite2D        # Reference to the Sprite2D node

# Offset for sword's position (adjust this based on where you want it on the player)
var sword_offset := Vector2(2, 0)  # Adjust to match the correct position relative to the player

# Called when the sword node is first loaded
func _ready():
	# Get the parent node, and assign it to the "player" variable if it is a "Player" node
	var parent := get_parent()
	if parent is Player:
		player = parent
	else:
		print("Warning: Sword is not attached to Player!")

# Function to play the sword swing animation
func swing():
	anim.play("swing")  # Plays the animation named "swing"

# Called every frame (_delta is the time since last frame)
func _process(_delta: float):
	if player == null:
		print("Warning: Sword has no player assigned!")
		return  # Prevent error

	# The sword is a child of the player, so we don't need to manually set its position.
	# Instead, we adjust the sword's local position using sword_offset.
	position = sword_offset  # The sword's position is now offset relative to the player’s position

	# Flip the sword based on the player's velocity (moving right or left)
	if player.velocity.x > 0:
		scale.x = 1  # Sword faces right
	elif player.velocity.x < 0:
		scale.x = -1  # Sword faces left

	# Check if the player presses the "E" key to swing the sword
	if Input.is_action_just_pressed("swing_sword"):
		swing()

# Called when a body enters the Area2D
func _on_area_2d_body_entered(body: Node2D):
	if body is Goober and player != null:
		player.stomped.emit(body)
