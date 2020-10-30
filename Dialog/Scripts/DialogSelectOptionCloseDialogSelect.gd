extends "res://Dialog/Scripts/DialogSelectOptionBasic.gd"


func clicked():
	if DialogController.dialog_select:
		DialogController.dialog_select.close()


func set_text(max_width: int):
	var text = tr("CLOSE_DIALOG_SELECT")
	var text_breaker = TextBreak.new(self.textLabel.get_font("font"))
	self.textLabel.text = text_breaker.format_text(text, max_width)
