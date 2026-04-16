extends Label
func _process(delta: float) -> void:
   var fps = Performance.get_monitor(Performance.TIME_FPS)
   text = "FPS: %d" % fps
