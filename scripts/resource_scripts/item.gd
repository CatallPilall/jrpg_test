extends Resource

class_name item

@export var item_name : String

@export var item_icon_path : String

@export var item_description : String

enum enum_item_type {CONSUMABLE,RELIC,VALUABLE}
@export var item_type : enum_item_type

@export var item_value : int

@export var item_skill : skill
