tool
extends EditorPlugin

var button_png := Button.new()
var tilemap: TileMap = null

class TilemapData:
	var position: Vector2
	var width: float
	var height: float
	
	func _init(position: Vector2 = Vector2.ZERO, width: float = 0, height: float = 0) -> void:
		self.position = position
		self.width = width
		self.height = height

var t_data := TilemapData.new()

func _enter_tree() -> void:
	get_editor_interface().get_selection().connect("selection_changed", self, "_selectionchanged")
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, button_png)
	button_png.text = "Save to PNG"

func _exit_tree() -> void:
	remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU,button_png)
	button_png.queue_free()

func _ready() -> void:
	button_png.connect("pressed", self, "_on_button_pressed")

func _selectionchanged() -> void:
	var selected := get_editor_interface().get_selection().get_selected_nodes()
	if selected.size() == 1:
		if selected[0] is TileMap:
			button_png.visible = true
			tilemap = selected[0]
			t_data.position = tilemap.get_used_rect().position
			t_data.width = tilemap.get_used_rect().size.x + 5
			t_data.height = tilemap.get_used_rect().size.y
		else:
			button_png.visible = false
	else:
		button_png.visible = false

func _on_button_pressed() -> void:
	save_to_png()

func save_to_png() -> void:
	# TODO: Clean this shit up and solve the offset issue
	print("Saving to png...")
	var image := Image.new()
	var offset := Vector2.ZERO
	if t_data.position.y < 0:
		var x = (t_data.position.y * -1)
		offset.y = x
		for i in range(x):
			t_data.position.y += 1
			t_data.height += 1
	if t_data.position.x < 0:
		var x = (t_data.position.x * -1)
		offset.x = x
		for i in range(x):
			t_data.position.x += 1
			t_data.width += 1
	image.create(t_data.width, t_data.height, false, Image.FORMAT_RGB8)
	image.lock()
	for y in range(t_data.height):
		for x in range(t_data.width):
			if tilemap.get_cell(x - offset.x, y-offset.y) != TileMap.INVALID_CELL:
				image.set_pixel(x, y, Color.white)
	image.unlock()
	image.save_png("res://test.png")
	print("Saved!")
