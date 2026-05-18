extends CanvasLayer
@onready var timer: Timer = $Timer
@onready var crazy_label: Label = $crazyLabel
var crazyThings:=["Find the light","Restore the beacon","Don't let the darkness win","You are here for a reason","You have a purpose","Such splendid purpose","It doesn't want you to succeed","Burn the dark","It hates the light","It fears the light","It waits in the dark","Don't you feel it?","It's watching you","Why are you here?","Where will you go?","What are you?","Do you remember?","What did you do?","The sirens call beyond the sea","You were expected","You were chosen","You were perfect","It is a gift","It binds and burns","It gnashes and rages","It wants out","You are the key","The key can't be lost","You are the torch","The torch can't burn out","The prison of The Depths","The kingdom of The Sky","The glaring gaze","It can see you","It can feel you","It can hear you","You can't leave","You aren't done"]
var centerX=0
var centerY=0
var hallucount:=0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	centerX=crazy_label.global_position.x
	centerY=crazy_label.global_position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hallucount>7:
		crazy_label.modulate=Color.RED
	else:
		crazy_label.modulate=Color.WHITE
	if hallucount>8:
		hallucount=8
	print(hallucount)
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
	

func _on_timer_timeout() -> void:
	timer.start(randi_range(50,165))
	Manager.losingIt=true
	crazy_label.text=crazyThings[randi_range(0,crazyThings.size()-1)]
	await get_tree().create_timer(randi_range(3,4)).timeout
	Manager.losingIt=false
	crazy_label.visible=false
