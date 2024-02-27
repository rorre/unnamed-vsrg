extends Node
class_name Level

@export var audio_file: AudioStream
@export var chart_file: Resource

# [miss, good, great, perfect]
var grades = [0,0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.stream = audio_file
	$Playfield.load_chart(chart_file)
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time = $AudioStreamPlayer.get_playback_position() + AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	time *= 1000

	$Playfield.set_current_time(time)


func _on_playfield_note_judged(judgement: int) -> void:
	grades[judgement] += 1
	
	var sum_notes =  grades.reduce(func (acc, e): return acc + e, 0)
	var acc = (grades[3] * 1 + grades[2] * 0.75 + grades[1] * 0.5) / sum_notes * 100
	var rounded = snapped(acc, 0.01)
	$CanvasLayer/Accuracy.text = str(rounded) + "%"
