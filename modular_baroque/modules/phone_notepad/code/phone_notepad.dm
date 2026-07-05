/obj/item/smartphone
	var/notepad_text = ""

/obj/item/smartphone/proc/sanitize_phone_notepad_text(text)
	if(!istext(text))
		return ""
	text = strip_html(text, PHONE_NOTEPAD_MAX_LENGTH)
	return copytext_char(trim(text), 1, PHONE_NOTEPAD_MAX_LENGTH + 1)

/obj/item/smartphone/proc/get_phone_notepad_ui_data()
	return list(
		"notepad_text" = notepad_text,
		"notepad_max_length" = PHONE_NOTEPAD_MAX_LENGTH,
	)

/obj/item/smartphone/proc/handle_phone_notepad_ui_act(action, list/params, datum/tgui/ui)
	switch(action)
		if("notepad_save")
			var/body = sanitize_phone_notepad_text(params["body"])
			notepad_text = body
			if(ui?.user)
				balloon_alert(ui.user, "Note saved.")
			return TRUE
		if("notepad_clear")
			notepad_text = ""
			if(ui?.user)
				balloon_alert(ui.user, "Note cleared.")
			return TRUE
	return FALSE