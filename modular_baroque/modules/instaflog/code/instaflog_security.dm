/// Stable per-body identity. Mind persists across respawns; DNA identity does not.
/proc/instaflog_get_character_identity(mob/living/mob)
	if(!ishuman(mob))
		return null
	var/mob/living/carbon/human/human_mob = mob
	return human_mob.dna?.unique_identity

/proc/instaflog_generate_salt()
	return copytext(md5("[world.realtime][world.timeofday][rand(1, 999999)]"), 1, 17)

/proc/instaflog_hash_password(password, salt)
	return rustg_hash_string(RUSTG_HASH_SHA256, "[salt][password]")

/proc/validate_instaflog_password(password, mob/viewer = null, confirm_password = null)
	if(!istext(password))
		password = ""
	password = trim(password)
	if(length(password) < INSTAFLOG_MIN_PASSWORD)
		if(viewer)
			to_chat(viewer, span_warning("A senha deve ter pelo menos [INSTAFLOG_MIN_PASSWORD] caracteres."))
		return FALSE
	if(length(password) > INSTAFLOG_MAX_PASSWORD)
		if(viewer)
			to_chat(viewer, span_warning("A senha pode ter no máximo [INSTAFLOG_MAX_PASSWORD] caracteres."))
		return FALSE
	if(!isnull(confirm_password) && password != confirm_password)
		if(viewer)
			to_chat(viewer, span_warning("As senhas não coincidem."))
		return FALSE
	return TRUE

/proc/instaflog_verify_password(password, password_hash, salt)
	if(!length(password_hash) || !length(salt))
		return FALSE
	return instaflog_hash_password(password, salt) == password_hash

/proc/sanitize_instaflog_text(text, max_length = MAX_MESSAGE_LEN)
	if(!istext(text))
		return ""
	text = strip_html(text, max_length)
	text = trim(text)
	return copytext_char(text, 1, max_length + 1)

/proc/instaflog_text_breaches_masquerade(text)
	return SSmasquerade.masquerade_breaching_phrase_regex && findtext(LOWER_TEXT(text), SSmasquerade.masquerade_breaching_phrase_regex)

/proc/validate_instaflog_text(text, mob/viewer, field_name = "texto")
	if(!length(text))
		if(viewer)
			to_chat(viewer, span_warning("O [field_name] não pode ficar vazio."))
		return FALSE
	if(viewer && instaflog_text_breaches_masquerade(text))
		to_chat(viewer, span_warning("Esse [field_name] contém termos proibidos."))
		return FALSE
	return TRUE

/proc/instaflog_mob_visible_masquerade_violation(mob/living/mob)
	if(!mob || QDELETED(mob) || !get_vampire_splat(mob))
		return FALSE
	if(HAS_TRAIT(mob, TRAIT_OBFUSCATED))
		return FALSE
	if(HAS_TRAIT(mob, TRAIT_UNMASQUERADE))
		return TRUE
	if(!iscarbon(mob))
		return FALSE
	var/mob/living/carbon/carbon_mob = mob
	if(HAS_TRAIT(carbon_mob, TRAIT_MASQUERADE_VIOLATING_FACE) && !(carbon_mob.obscured_slots & HIDEFACE))
		return TRUE
	if(HAS_TRAIT(carbon_mob, TRAIT_MASQUERADE_VIOLATING_EYES) && !carbon_mob.is_eyes_covered())
		return TRUE
	return FALSE

/proc/instaflog_picture_contains_violating_vampire(datum/picture/picture)
	if(!picture)
		return null
	for(var/datum/weakref/mob_ref as anything in picture.mobs_seen)
		var/mob/living/living_mob = mob_ref.resolve()
		if(!living_mob || QDELETED(living_mob))
			continue
		if(instaflog_mob_visible_masquerade_violation(living_mob))
			return living_mob
	return null

/obj/item/smartphone/proc/instaflog_handle_photo_masquerade(datum/picture/picture, mob/living/poster)
	var/mob/living/exposed_vampire = instaflog_picture_contains_violating_vampire(picture)
	if(!exposed_vampire)
		return FALSE

	SEND_SIGNAL(exposed_vampire, COMSIG_MASQUERADE_VIOLATION)
	if(poster && poster != exposed_vampire && !ismundane(poster))
		SEND_SIGNAL(poster, COMSIG_MASQUERADE_VIOLATION)

	if(poster)
		to_chat(poster, span_userdanger("Publicar essa foto violou a Máscara!"))
	log_game("[key_name(poster)] published an InstaFlog photo exposing masquerade violation by [exposed_vampire]")
	return TRUE

/datum/controller/subsystem/phones/proc/trim_instaflog_feed()
	while(length(instaflog_posts) > INSTAFLOG_MAX_FEED_POSTS)
		var/datum/instaflog_post/oldest = instaflog_posts[1]
		instaflog_posts.Cut(1, 2)
		qdel(oldest)
