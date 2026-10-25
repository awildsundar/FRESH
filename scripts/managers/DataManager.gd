extends Node

signal inventory_updated
signal shards_updated(value: int)
signal cash_updated(value: int)

var cash: int:
	set(value):
		cash = value
		cash_updated.emit(value)
var shards: int:
	set(value):
		shards = value
		shards_updated.emit(value)
var inventory: Dictionary[Item, int]
var arena_entered: bool = false
