extends ColorRect


onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play_backwards("Fade")


func fadeIn():
	animation_player.play("Fade")


func fadeOut():
	animation_player.play_backwards("Fade")
