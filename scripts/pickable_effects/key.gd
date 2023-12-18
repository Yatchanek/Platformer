extends Resource
class_name Key

var description : String
var type : Globals.KeyTypes

func initialize(_type : Globals.KeyTypes):
	type = _type
	description = Globals.key_names[type]

