/client/New(TopicData)
	. = ..()
	check_region_gate()

/client/proc/check_region_gate()
	if(!SSregion_gate.is_enabled())
		return
	if(!SSregion_gate.should_reject_connection(src))
		return

	var/list/contact_where = list()

	var/message_string = "Your connection was denied. This server only accepts players from Spanish- or Portuguese-speaking countries."
	if(length(contact_where))
		message_string += " If you believe this is an error or have any questions, please contact us on our Discord server: discord.gg/X8Z23N7XFU"
	else
		message_string += " If you believe this is an error, please contact the administration."

	to_chat_immediate(src, span_userdanger(message_string))
	qdel(src)
