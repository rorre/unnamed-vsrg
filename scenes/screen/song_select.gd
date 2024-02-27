extends CanvasLayer

signal song_selected(song, diff)

const songs = [
	{
		"artist": "ああああ",
		"title": "コドモチック・フィロソフィ",
		"jacket": "res://songs/childish/jacket.jpg",
		"audio": "res://songs/childish/audio.mp3",
		"difficulties": [
			{
				"level": 10,
				"chart": "res://songs/childish/expert.json"
			}
		]
	},
	{
		"artist": "xi",
		"title": "FREEDOM DiVE",
		"jacket": "res://songs/fd/jacket.png",
		"audio": "res://songs/fd/audio.mp3",
		"difficulties": [
			{
				"level": 15,
				"chart": "res://songs/fd/master.json"
			}
		]
	}
]

const song_box = preload("res://scenes/components/song_box.tscn")
var selected_idx = 0
var selected_difficulty = 0
var boxes: Array[SongBox] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for song in songs:
		var box: SongBox = song_box.instantiate()
		box.artist = song["artist"]
		box.title = song["title"]
		box.difficulty = song["difficulties"][0]["level"]
		box.jacket = load(song["jacket"])
		
		$SongsContainer/HBoxContainer.add_child(box)
		boxes.append(box)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		selected_idx = clamp(selected_idx + 1, 0, len(songs) - 1)
		selected_difficulty = 0
	elif Input.is_action_just_pressed("ui_left"):
		selected_idx = clamp(selected_idx - 1, 0, len(songs) - 1)
		selected_difficulty = 0
	elif Input.is_action_just_pressed("ui_up"):
		selected_difficulty = clamp(selected_difficulty + 1, 0, len(songs[selected_idx]["difficulties"]) - 1)
	elif Input.is_action_just_pressed("ui_down"):
		selected_difficulty = clamp(selected_difficulty - 1, 0, len(songs[selected_idx]["difficulties"]) - 1)
	elif Input.is_action_just_pressed("ui_accept"):
		song_selected.emit(songs[selected_idx], selected_difficulty)
	
	for i in range(len(boxes)):
		boxes[i].scale = Vector2(1, 1)
	boxes[selected_idx].scale = Vector2(1.1, 1.1)
	boxes[selected_idx].difficulty = songs[selected_idx]["difficulties"][selected_difficulty]["level"]
