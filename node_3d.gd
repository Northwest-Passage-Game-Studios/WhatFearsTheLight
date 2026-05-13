extends Node3D
@onready var eyeball: MeshInstance3D = $Eyeball
@onready var look_around_timer: Timer = $lookAroundTimer
@onready var player: player_body = $"../Player"
var gazing:=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func lookAround()->void:
	var ifLook:=randi_range(0,1)
	if !gazing:
		var newRotation = Vector3(randi_range(-135,-45),randi_range(-65,65),randi_range(-65,65))
		var looktween = create_tween()
		looktween.set_trans(Tween.TRANS_SINE)
		looktween.tween_property(self,"rotation_degrees",newRotation,2)
	else:
		look_around_timer.stop()
		var oldRotation=self.rotation_degrees
		look_at(player.global_position)
		var newRotation=self.rotation_degrees
		rotation_degrees=oldRotation
		var looktween = create_tween()
		looktween.set_trans(Tween.TRANS_SINE)
		looktween.tween_property(self,"rotation_degrees",newRotation,0.5)
		await looktween.finished
		lookAround()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_look_around_timer_timeout() -> void:
	lookAround()
	look_around_timer.start(randf_range(2.0,4.0))


func _on_area_3d_body_entered(body: Node3D) -> void:
	gazing=true


func _on_area_3d_body_exited(body: Node3D) -> void:
	gazing=false
	look_around_timer.start(randf_range(2.0,4.0))
