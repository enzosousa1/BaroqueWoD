#define MAYOR_ANNOUNCEMENT_COOLDOWN 2 MINUTES

/obj/structure/mayor_console
	name = "Mayor's Console"
	desc = "The administrative terminal for the Mayor of Santa Augustina."
	icon = 'modular_darkpack/modules/deprecated/icons/props.dmi'
	icon_state = "computer"
	anchored = TRUE
	density = TRUE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	COOLDOWN_DECLARE(announcement_cooldown)

	var/last_announcement = "No city announcements have been issued this term."
	var/last_announcer = "N/A"

/obj/structure/mayor_console/examine(mob/user)
	. = ..()
	if(last_announcement != "No city announcements have been issued this term.")
		. += span_notice("The screen displays the latest bulletin from [last_announcer].")

/obj/structure/mayor_console/attack_hand(mob/user)
	. = ..()
	if(!mayor_console_has_access(user))
		to_chat(user, span_warning("This console is restricted to the Mayor of Santa Augustina."))
		return
	ui_interact(user)

/obj/structure/mayor_console/ui_status(mob/user, datum/ui_state/state)
	if(!mayor_console_has_access(user))
		return UI_CLOSE
	return ..()

/obj/structure/mayor_console/ui_state(mob/user)
	return GLOB.physical_state

/obj/structure/mayor_console/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MayorConsole", name)
		ui.open()

/obj/structure/mayor_console/ui_data(mob/user)
	var/list/data = list()
	data["last_announcement"] = last_announcement
	data["last_announcer"] = last_announcer
	data["mayor_name"] = user.real_name
	data["on_cooldown"] = COOLDOWN_TIMELEFT(src, announcement_cooldown)
	data["city_stats"] = get_mayor_console_city_stats()
	return data

/obj/structure/mayor_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!mayor_console_has_access(usr))
		to_chat(usr, span_warning("You are not authorized to use this console."))
		return FALSE
	switch(action)
		if("send_announcement")
			if(!params["message"])
				to_chat(usr, span_warning("You must write a message."))
				return FALSE
			if(!COOLDOWN_FINISHED(src, announcement_cooldown))
				to_chat(usr, span_warning("Please wait before issuing another announcement."))
				return FALSE
			var/message = trim(copytext_char(sanitize(params["message"]), 1, MAX_MESSAGE_LEN))
			if(!length(message))
				to_chat(usr, span_warning("That message is empty."))
				return FALSE
			mayor_broadcast_announcement(message, usr.real_name)
			last_announcement = message
			last_announcer = usr.real_name
			COOLDOWN_START(src, announcement_cooldown, MAYOR_ANNOUNCEMENT_COOLDOWN)
			to_chat(usr, span_notice("Your announcement has been broadcast across Santa Augustina."))
			message_admins("[key_name(usr)] issued a mayor announcement: \"[message]\"")
			return TRUE
		if("send_emergency_notice")
			if(!COOLDOWN_FINISHED(src, announcement_cooldown))
				to_chat(usr, span_warning("Please wait before issuing another announcement."))
				return FALSE
			var/message = "The Mayor has declared a city emergency. Remain calm and follow instructions from city officials."
			mayor_broadcast_announcement(message, usr.real_name, emergency = TRUE)
			last_announcement = message
			last_announcer = usr.real_name
			COOLDOWN_START(src, announcement_cooldown, MAYOR_ANNOUNCEMENT_COOLDOWN)
			to_chat(usr, span_notice("Emergency notice broadcast."))
			message_admins("[key_name(usr)] issued a mayor emergency notice.")
			return TRUE

/proc/mayor_console_has_access(mob/user)
	if(!isliving(user))
		return FALSE
	var/mob/living/living_user = user
	if(istype(living_user.mind?.assigned_role, /datum/job/vampire/mayor))
		return TRUE
	for(var/obj/item/vamp/keys/keys in living_user)
		if(LOCKACCESS_MAYOR in keys.accesslocks)
			return TRUE
	return FALSE

/proc/get_mayor_console_city_stats()
	var/population = 0
	var/townhall_staff = 0
	var/city_services = 0
	for(var/mob/player_mob as anything in GLOB.player_list)
		if(!isliving(player_mob) || !player_mob.mind)
			continue
		population++
		var/datum/job/job = player_mob.mind.assigned_role
		if(!job)
			continue
		if(job.faction == FACTION_TOWNHALL)
			townhall_staff++
		if(job.department_for_prefs == /datum/job_department/city_services)
			city_services++
	return list(
		"population" = population,
		"townhall_staff" = townhall_staff,
		"city_services" = city_services,
		"round_time" = round(world.time / 600),
	)

/proc/mayor_broadcast_announcement(message, announcer, emergency = FALSE)
	var/title = emergency ? "Anúncio de Emergencia" : "Anúncio do Prefeito"
	var/sender = "[announcer], Prefeito de Santa Augustina"
	priority_announce(
		message,
		title = title,
		sender_override = sender,
	)
	mayor_update_public_displays(message, emergency)

/proc/mayor_update_public_displays(message, emergency = FALSE)
	for(var/obj/item/smartphone/phone as anything in GLOB.phones_list)
		phone.say(emergency ? "City emergency notice!" : "New city announcement!")
	instaflog_announce(message, "Prefeito de Santa Augustina")

#undef MAYOR_ANNOUNCEMENT_COOLDOWN
