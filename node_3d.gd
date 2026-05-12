extends Node3D
@onready var eyeball: MeshInstance3D = $Eyeball
@onready var look_around_timer: Timer = $lookAroundTimer
@onready var player: player_body = $"../Player"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func lookAround()->void:
	var ifLook:=randi_range(0,1)
	if ifLook==0:
		var newRotation = Vector3(randi_range(-65,65),randi_range(-65,65),randi_range(-65,65))
		var looktween = create_tween()
		looktween.set_trans(Tween.TRANS_SINE)
		looktween.tween_property(self,"rotation_degrees",newRotation,3)
	else:
		var oldRotation=self.rotation_degrees
		look_at(player.global_position)
		var newRotation=self.rotation_degrees
		rotation_degrees=oldRotation
		var looktween = create_tween()
		looktween.set_trans(Tween.TRANS_SINE)
		looktween.tween_property(self,"rotation_degrees",newRotation,3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_look_around_timer_timeout() -> void:
	lookAround()
	look_around_timer.start(randf_range(3.0,4.0))
