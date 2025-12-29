@tool
extends CodeEdit
@export var codes_to_complete: PackedStringArray

func _ready() :
	text_changed.connect(code_request_code_completion)
	code_completion_enabled = true

func code_request_code_completion():
	for c in codes_to_complete:
		add_code_completion_option(CodeEdit.KIND_FUNCTION, c, c)
	update_code_completion_options(true)
