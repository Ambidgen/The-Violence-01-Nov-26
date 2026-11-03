extends Control
## Campaign board overview. This draws the generator's actual ward polygons, river,
## basins and major roads; pins use the coordinates saved with each situation. It is
## an overview, not the tactical floor plan, and does not change simulation state.

const City = preload("res://scripts/campaign/city.gd")
const Ink = preload("res://scripts/view/ink.gd")
const C = preload("res://scripts/view/crayon.gd")
# Visual overhaul 2026-11-03: the board map was flat vector beige and read as a different
# game from the opening scenes. It is now drawn in the opening's crayon palette.
const PAPER := Color("#fbf7ec")
const CHARCOAL := Color("#1e1b1c")
const PENCIL := Color("#5b5866")
const WATER := Color("#16b7ff")
const WATER_EDGE := Color("#2747e6")
const ROAD := Color("#8a909b")
const RED := Color("#ff2b30")
const WARD_COLORS := [Color("#ffd166"), Color("#ff8fab"), Color("#86e35c"),
	Color("#c69cff"), Color("#ffb36b"), Color("#f2b866")]
# Label positions are cartographic annotations only, in the generator's metre frame.
const LABELS := {
	"northgate": [0.0, 2000.0], "riverside": [-2300.0, 650.0], "oldtown": [0.0, 620.0],
	"ironworks": [-2000.0, -1250.0], "eastport": [3000.0, -1200.0], "kilbride": [1050.0, -1200.0]
}

var situations: Array = []
var trust: Array = []
var week := 1
var _extent: Array = []
var _map_rect := Rect2()
var _ink_rev := -1


func show_city(board: Array, ward_trust: Array, current_week: int) -> void:
	situations = board
	trust = ward_trust
	week = current_week
	visible = true
	queue_redraw()


func _process(_delta: float) -> void:
	if visible and _ink_rev != Ink.rev:
		_ink_rev = Ink.rev
		queue_redraw()


func _point(x: float, y: float) -> Vector2:
	var xmin: float = float(_extent[0])
	var ymin: float = float(_extent[1])
	var xmax: float = float(_extent[2])
	var ymax: float = float(_extent[3])
	return Vector2(_map_rect.position.x + (x - xmin) / (xmax - xmin) * _map_rect.size.x,
		_map_rect.end.y - (y - ymin) / (ymax - ymin) * _map_rect.size.y)


## Native Control tooltip, using the same projection as the drawn pins.
func _get_tooltip(at_position: Vector2) -> String:
	if _extent.size() != 4:
		return ""
	var nearest := -1
	var distance := 14.0
	for i in situations.size():
		var s: Dictionary = situations[i]
		if not s.has("city_x") or not s.has("city_y"):
			continue
		var d := _point(float(s["city_x"]), float(s["city_y"])).distance_to(at_position)
		if d <= distance:
			distance = d
			nearest = i
	if nearest < 0:
		return ""
	var s: Dictionary = situations[nearest]
	return "%d. %s\n%s\n%s" % [nearest + 1, s.get("site_name", s.get("title", "Call")),
		s.get("address", "Location unavailable"), s.get("ward", "Unknown ward")]


func _points(raw: Array) -> PackedVector2Array:
	var out := PackedVector2Array()
	for xy in raw:
		if xy is Array and xy.size() >= 2:
			out.append(_point(float(xy[0]), float(xy[1])))
	return out


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), PAPER)
	var font: Font = ThemeDB.fallback_font
	C.letters(self, "PORT CARRICK  /  WEEK %d" % week, Vector2(36, 54), 30, CHARCOAL, 7, 2, 0.9)
	C.line(self, Vector2(36, 64), Vector2(36 + C.letters_width("PORT CARRICK  /  WEEK %d" % week, 30, 0.9), 64), RED, 3.0, 8, 1.2, 2)
	draw_string(font, Vector2(37, 88), "City file  ·  ward trust and this week's calls", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, PENCIL)
	var city := City.data()
	if city.has("error"):
		draw_string(font, Vector2(37, 122), "City map unavailable. Check port-carrick/city.json.", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, CHARCOAL)
		return
	_extent = city.get("extent", [])
	if _extent.size() != 4 or float(_extent[2]) <= float(_extent[0]) or float(_extent[3]) <= float(_extent[1]):
		return
	var available := Vector2(maxf(1.0, size.x - 76.0), maxf(1.0, size.y - 175.0))
	var aspect := (float(_extent[2]) - float(_extent[0])) / (float(_extent[3]) - float(_extent[1]))
	var w := minf(available.x, available.y * aspect)
	var h := w / aspect
	_map_rect = Rect2(Vector2((size.x - w) * 0.5, 106.0 + (available.y - h) * 0.5), Vector2(w, h))
	var wards: Dictionary = city.get("wards", {})
	for i in City.WARD_IDS.size():
		var id: String = City.WARD_IDS[i]
		var k := 0
		for polygon in wards.get(id, []):
			if not (polygon is Array):
				continue
			var pts := _points(polygon)
			if pts.size() >= 3:
				var col: Color = WARD_COLORS[i]
				C.hatch(self, pts, Color(col, 0.75), 4.6, -0.6 + 0.25 * i, 300 + i * 7 + k, 3.4)
				C.outline(self, pts, col.darkened(0.35), 2.4, 320 + i * 7 + k, 1.0)
				k += 1
	var water: Dictionary = city.get("water", {}) if city.get("water", {}) is Dictionary else {}
	var wk := 0
	for polygon in water.get("river", []):
		if not (polygon is Array):
			continue
		var pts := _points(polygon)
		if pts.size() >= 3:
			C.hatch(self, pts, Color(WATER, 0.85), 4.0, -0.25, 400 + wk, 3.6)
			C.outline(self, pts, WATER_EDGE, 2.6, 410 + wk, 1.0)
			wk += 1
	var basins = water.get("basins", {})
	if basins is Dictionary:
		for basin in basins.values():
			if not (basin is Dictionary) or not (basin.get("rect", []) is Array):
				continue
			var r: Array = basin.get("rect", [])
			if r.size() == 4:
				var a2 := _point(float(r[0]), float(r[1]))
				var b2 := _point(float(r[2]), float(r[3]))
				var rr := Rect2(Vector2(minf(a2.x, b2.x), minf(a2.y, b2.y)), Vector2(absf(a2.x - b2.x), absf(a2.y - b2.y)))
				C.hatch_rect(self, rr, Color(WATER, 0.85), 4.0, -0.25, 420 + wk, 3.6)
				C.outline(self, C.rect_poly(rr), WATER_EDGE, 2.4, 430 + wk, 1.0)
				wk += 1
	var sk := 0
	for street in city.get("streets", []):
		if not (street is Dictionary) or not (street.get("pts", []) is Array):
			continue
		var cls := String(street.get("cls", ""))
		if not cls in ["A", "B", "C", "M", "Q", "S"]:
			continue
		var pts := _points(street.get("pts", []))
		var wide := 2.4 if cls in ["A", "M"] else 1.5
		for j in range(1, pts.size()):
			C.line(self, pts[j - 1], pts[j], Color(ROAD, 0.85), wide, 500 + sk * 13 + j, 0.7, 1)
		sk += 1
	C.outline(self, C.rect_poly(_map_rect), CHARCOAL, 3.0, 9, 1.4)
	for i in City.WARD_IDS.size():
		var id: String = City.WARD_IDS[i]
		var xy: Array = LABELS[id]
		var pos := _point(float(xy[0]), float(xy[1]))
		var value := "  %d" % int(trust[i]) if i < trust.size() else ""
		var name: String = "OLD TOWN" if id == "oldtown" else id.to_upper()
		var label := name + value
		var lw := C.letters_width(label, 18, 0.9)
		C.letters(self, label, pos + Vector2(-lw * 0.5, 6), 18, CHARCOAL, 600 + i, 2, 0.9)
	var unlocated := 0
	for i in situations.size():
		var s: Dictionary = situations[i]
		if not s.has("city_x") or not s.has("city_y"):
			unlocated += 1
			continue
		var pos := _point(float(s["city_x"]), float(s["city_y"]))
		var open: bool = s.get("status", "open") == "open"
		var dot := C.ellipse_poly(pos, 15.0, 15.0, 16, 700 + i, 0.08)
		C.hatch(self, dot, RED if open else ROAD, 2.6, 0.6, 710 + i, 3.6)
		C.outline(self, dot, CHARCOAL, 2.4, 720 + i, 1.0)
		var num := str(i + 1)
		C.letters(self, num, pos + Vector2(-C.letters_width(num, 18, 0.9) * 0.5, 8), 18, Color.WHITE, 730 + i, 2, 0.9)
	var footer := "Pins match the numbered cards. Locations are canonical; tactical layouts are schematic."
	if unlocated > 0:
		footer += "  %d older/unlocated call(s) not pinned." % unlocated
	draw_string(font, Vector2(37, size.y - 38), footer, HORIZONTAL_ALIGNMENT_LEFT, maxf(1.0, size.x - 74.0), 13, PENCIL)
