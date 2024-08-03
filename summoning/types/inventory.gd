class_name Inventory

const Item := DraggableItem.Types

static var _items := {}


static func add_item(item: Item) -> void:
	if not _items.has(item):
		_items[item] = {&"amount": 0}
	_items[item][&"amount"] += 1


static func remove_item(item: Item) -> void:
	_items[item][&"amount"] -= 1
	if _items[item][&"amount"] < 1:
		_items.erase(item)


static func item_amount(item: Item) -> int:
	return _items.get(item, {}).get(&"amount", 0)


static func available_items() -> Array[Item]:
	var a: Array[Item] = []
	a.append_array(_items.keys())
	return a


static func add_blood(amount: int) -> void:
	if not _items.has(&"blood"):
		_items[&"blood"] = 0
	_items[&"blood"] += amount


static func remove_blood(amount: int) -> void:
	_items[&"blood"] = maxi(_items[&"blood"] - amount, 0)


static func get_blood() -> int:
	return _items.get(&"blood", 0)

