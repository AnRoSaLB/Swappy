extends CharacterBody2D



const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const COULDOWN_SWAP = 3

func _ready() -> void:
	get_parent().find_child("Introduction").play()

#var GRASS = $"../Grass"
func respawn():
	global_position.y=-10
	global_position.x=0
	velocity.y=0
	velocity.x=0
	if get_parent().find_child("Grass").modulate == Color.from_rgba8(255,255,255,50):
		get_parent().find_child("Caillou").modulate = Color.from_rgba8(255,255,255,50)
		get_parent().find_child("Grass").modulate = Color.from_rgba8(255,255,255,255)
		get_parent().find_child("Spike_Caillou").modulate = Color.from_rgba8(255,255,255,50)
		get_parent().find_child("Spike_Grass").modulate = Color.from_rgba8(255,255,255,255)
		get_parent().find_child("Spike_Caillou").collision_enabled = false
		get_parent().find_child("Spike_Grass").collision_enabled = true
		get_parent().find_child("Caillou").collision_enabled = false
		get_parent().find_child("Grass").collision_enabled = true
		get_parent().find_child("Sky").visible = true
		get_parent().find_child("Cave").visible = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("Swap"):
		if get_parent().find_child("Grass").modulate == Color.from_rgba8(255,255,255,255):
			get_parent().find_child("Grass").modulate = Color.from_rgba8(255,255,255,50)
			get_parent().find_child("Caillou").modulate = Color.from_rgba8(255,255,255,255)
			get_parent().find_child("Spike_Caillou").modulate = Color.from_rgba8(255,255,255,255)
			get_parent().find_child("Spike_Grass").modulate = Color.from_rgba8(255,255,255,50)
			get_parent().find_child("Spike_Caillou").collision_enabled = true
			get_parent().find_child("Spike_Grass").collision_enabled = false
			get_parent().find_child("Grass").collision_enabled = false
			get_parent().find_child("Caillou").collision_enabled = true
			get_parent().find_child("Sky").visible = false
			get_parent().find_child("Cave").visible = true
		else:
			get_parent().find_child("Caillou").modulate = Color.from_rgba8(255,255,255,50)
			get_parent().find_child("Grass").modulate = Color.from_rgba8(255,255,255,255)
			get_parent().find_child("Spike_Caillou").modulate = Color.from_rgba8(255,255,255,50)
			get_parent().find_child("Spike_Grass").modulate = Color.from_rgba8(255,255,255,255)
			get_parent().find_child("Spike_Caillou").collision_enabled = false
			get_parent().find_child("Spike_Grass").collision_enabled = true
			get_parent().find_child("Caillou").collision_enabled = false
			get_parent().find_child("Grass").collision_enabled = true
			get_parent().find_child("Sky").visible = true
			get_parent().find_child("Cave").visible = false
	get_parent().find_child("Bobby").global_position.x=get_parent().find_child("Swappy").global_position.x

	if global_position.y > 110:
		respawn()
	if velocity.y > 700:
		respawn()
	
		
	var vitesse = velocity
	move_and_slide()
	var nb_collision = get_slide_collision_count()	
	for c in nb_collision:
		var collision = get_slide_collision(c) 		
		if collision != null:
			var coll = collision.get_collider()
			if coll != null:
				if coll.name == "Spike_Caillou" or coll.name == "Spike_Grass":
					respawn()
				if coll.name == "Slime" :
					velocity.y = -vitesse.y * 0.98
					velocity.x = vitesse.x
					move_and_slide()


func _on_introduction_finished() -> void:
	get_parent().find_child("Thème").play()
