extends Node

var map_seed = 0

var DOORS_HIDDEN = true

func _ready():
	randomize()
	if !map_seed:
		map_seed = randi()
		seed(map_seed)
		print("Seed: ", map_seed)

func choose(array):
	array.shuffle()
	return array.front()