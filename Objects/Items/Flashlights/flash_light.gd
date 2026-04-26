extends Item

var is_broken:=false
@onready var click_switch: AudioStreamPlayer3D = $ClickSwitch
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var spot_light_3d: SpotLight3D = $SpotLight3D
@export var flashlightMaxDurability:=90.0
var flashlightDurability:=0.0
@onready var buzzing: AudioStreamPlayer = $buzzing
@onready var explode: AudioStreamPlayer = $explode

func _switched_on():
	click_switch.play()
	if _is_on==false:
		animation_player.play("Turn_on")
	else:
		animation_player.play_backwards("Turn_on")

func _ready() -> void:
	flashlightDurability=flashlightMaxDurability
	
func _process(delta: float) -> void:
	buzzing.volume_db=12-(flashlightDurability*3)
	Manager.flashlightOn=spot_light_3d.visible
	if _is_on:
		spot_light_3d.visible=true
		if flashlightDurability>-1 && !Manager.infiniFlash:
			flashlightDurability-=1*delta
		if int(flashlightDurability)==25||int(flashlightDurability)==28||int(flashlightDurability)==34:
				spot_light_3d.light_energy=randi_range(8,13)
				spot_light_3d.spot_attenuation=2.0
		elif flashlightDurability<12:
			if !buzzing.playing && flashlightDurability>1:
				buzzing.playing=true
			if flashlightDurability<5:
				spot_light_3d.light_energy=randi_range(0,12)
				spot_light_3d.spot_attenuation=randf_range(1.5,2.5)
				
			else:
				spot_light_3d.light_energy=randi_range(13,19)
				spot_light_3d.spot_attenuation=randf_range(2.0,2.2)
		elif flashlightDurability>0:
			spot_light_3d.light_energy=16
		if flashlightDurability<1:
			if !is_broken:
				explode.play()
				buzzing.stop()
			is_broken=true
			spot_light_3d.light_energy=0
			spot_light_3d.spot_range=0
	else:
		buzzing.playing=false
		spot_light_3d.visible=false
		if flashlightDurability>0 && !spot_light_3d.visible && !is_broken:
			if flashlightDurability<flashlightMaxDurability:
				flashlightDurability+=15*delta
			else:
				flashlightDurability=flashlightMaxDurability
