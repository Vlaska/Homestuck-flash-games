extends Reference

class_name TextBreak
var space_width: int
var dash_width: int
var font: Font


func _init(_font: Font):
	self.font = _font
	self.space_width = int(self.font.get_string_size(" ").x)
	self.dash_width = int(self.font.get_string_size("-").x)


func format_text(text: String, max_width: int) -> String:
	var lines = text.split("\n", true)
	var out = []
	for i in lines:
		out.append(break_line(text, max_width))
	var outText = lines[0]
	for i in range(1, len(lines)):
		outText += "\n" + out[i]

	return outText


# Source: https://xxyxyz.org/line-breaking/
func break_line(text, width):
	var words = text.split(" ", true)
	var count = len(words)
	var offsets = [0]
	for w in words:
		offsets.append(offsets[-1] + int(font.get_string_size(w).x))
	
	var minima = [0]
	var breaks = [0]
	for _i in range(count):
		minima.append(9223372036854775807)
		breaks.append(0)
	
	for i in range(count):
		var j = i + 1
		while j <= count:
			var w = offsets[j] - offsets[i] + j - i - 1
			if w > width:
				break
			var cost = minima[i] + (width - w) * (width - w)
			if cost < minima[j]:
				minima[j] = cost
				breaks[j] = i
			j += 1
	
	var lines = []
	var j = count
	
	while j > 0:
		var i = breaks[j]
		var line = words[i]
		for k in range(i, j):
			line += " " + words[k]
			j = i
		lines.append(line)
		j = i
	lines.invert()
	var out = lines[0]
	for i in range(1, len(lines)):
		out += '\n' + lines[i]
	return out
	
