extends Item

var is_broken:=false
@onready var click_switch: AudioStreamPlayer3D = $ClickSwitch
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D
@onready var spot_light_3d: SpotLight3D = $SpotLight3D
@export var flashlightMaxDurability:=40.0
var flashlightDurability:=0.0

func _switched_on():
	click_switch.play()
	if _is_on==false:
		animation_player.play("Turn_on")
	else:
		animation_player.play_backwards("Turn_on")

func _ready() -> void:
	flashlightDurability=flashlightMaxDurability
	
func _process(delta: float) -> void:
	if spot_light_3d.visible==true:
		if shape_cast_3d.is_colliding():
			var obj :Node3D= shape_cast_3d.get_collider(0)

			if obj is wendigo:
				obj.spook()
	if _is_on:
		spot_light_3d.visible=true
		if flashlightDurability>-1:
			flashlightDurability-=1*delta
		if int(flashlightDurability)==25||int(flashlightDurability)==28||int(flashlightDurability)==34:
				spot_light_3d.light_energy=randi_range(8,13)
		elif flashlightDurability<12:
			if flashlightDurability<5:
				spot_light_3d.light_energy=randi_range(0,12)
			else:
				spot_light_3d.light_energy=randi_range(13,19)
		elif flashlightDurability>0:
			spot_light_3d.light_energy=16
		if flashlightDurability<1:
			spot_light_3d.light_energy=0
			spot_light_3d.spot_range=0
		#else:
			#if flashlightDurability>0:
				#if flashlightDurability<flashlightMaxDurability:
					#flashlightDurability+=15*delta
				#else:
					#flashlightDurability=flashlightMaxDurability
	else:
		spot_light_3d.visible=false
