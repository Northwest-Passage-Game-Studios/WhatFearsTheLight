extends CanvasLayer
@export_file("*.json", "*.txt") var data_file: String

@onready var timer: Timer = $Timer
@onready var crazy_label: Label = $crazyLabel


var crazyThings:Array[String]=[]
var centerX=0
var centerY=0
var hallucount:=0.0
@onready var color_rect: ColorRect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	centerX=crazy_label.global_position.x
	centerY=crazy_label.global_position.y
	
	var loaded = FileAccess.get_file_as_string(data_file)
	var packed_texts := loaded.split("\n")
	for line in packed_texts:
		crazyThings.append(line)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hallucount>7:
		crazy_label.modulate=Color.RED
	else:
		crazy_label.modulate=Color.WHITE
	if hallucount>8:
		hallucount=8
		color_rect.color.a+=0.01
		if color_rect.color.a>0.99:
			get_tree().reload_current_scene()
	crazy_label.position.x=centerX+randi_range(-30-hallucount*10,30+hallucount*10)
	crazy_label.position.y=centerY+randi_range(-20-hallucount*10,20+hallucount*10)
	if Manager.losingIt:
		hallucount+=0.01
		var visibler=randi_range(0,10)
		crazy_label.visible=visibler<1+int(hallucount/4)
		if visibler==1:
			var visiblery=randi_range(0,10)
			if visiblery<5+hallucount*10:
				crazy_label.text=crazyThings[randi_range(0,crazyThings.size()-1)]
	else:
		crazy_label.visible=false
		hallucount=0
		if color_rect.color.a>0:
			color_rect.color.a-=0.01
	

func _on_timer_timeout() -> void:
	timer.start(randi_range(50,165))
	Manager.losingIt=true
	crazy_label.text=crazyThings[randi_range(0,crazyThings.size()-1)]
	await get_tree().create_timer(randi_range(3,4)).timeout
	Manager.losingIt=false
	crazy_label.visible=false
