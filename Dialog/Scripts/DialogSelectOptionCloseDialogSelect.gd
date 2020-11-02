extends "res://Dialog/Scripts/DialogSelectOptionBasic.gd"


func clicked():
	WorldController.close_dialog_select()


func set_text(max_width: int):
	var text = tr("CLOSE_DIALOG_SELECT")
	var text_breaker = TextBreak.new(self.textLabel.get_font("font"))
	self.textLabel.text = text_breaker.format_text(text, max_width)
