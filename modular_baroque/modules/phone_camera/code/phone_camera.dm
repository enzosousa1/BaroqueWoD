/datum/phone_gallery_photo
	var/datum/picture/picture
	var/time_taken = ""

/datum/phone_gallery_photo/Destroy(force)
	QDEL_NULL(picture)
	return ..()

/obj/item/camera/phone
	print_picture_on_snap = FALSE
	can_customise = FALSE
	cooldown = 1 SECONDS
	silent = TRUE
	pictures_left = 999
	pictures_max = 999

/obj/item/camera/phone/after_picture(mob/user, datum/picture/picture)
	var/obj/item/smartphone/phone = loc
	if(!istype(phone))
		return
	phone.store_gallery_photo(picture, user)
	if(silent && user)
		user.playsound_local(get_turf(phone), SFX_POLAROID, 35, TRUE)
	else
		playsound(loc, SFX_POLAROID, 75, TRUE)

/obj/item/smartphone
	var/list/gallery_photos = list()
	var/camera_mode_active = FALSE
	var/obj/item/camera/phone/phone_camera
	var/datum/phone_gallery_photo/viewing_photo

/obj/item/smartphone/proc/ensure_phone_camera()
	if(phone_camera && !QDELETED(phone_camera))
		return phone_camera
	phone_camera = new(src)
	return phone_camera

/obj/item/smartphone/proc/start_camera_mode()
	if(camera_mode_active)
		return
	camera_mode_active = TRUE
	ensure_phone_camera()
	RegisterSignal(src, COMSIG_RANGED_ITEM_INTERACTING_WITH_ATOM_SECONDARY, PROC_REF(on_phone_camera_ranged_interact))

/obj/item/smartphone/proc/stop_camera_mode()
	if(!camera_mode_active)
		return
	camera_mode_active = FALSE
	UnregisterSignal(src, COMSIG_RANGED_ITEM_INTERACTING_WITH_ATOM_SECONDARY)

/obj/item/smartphone/proc/cleanup_phone_camera()
	stop_camera_mode()
	viewing_photo = null
	for(var/datum/phone_gallery_photo/entry as anything in gallery_photos)
		qdel(entry)
	gallery_photos.Cut()
	QDEL_NULL(phone_camera)

/obj/item/smartphone/proc/on_phone_camera_ranged_interact(datum/source, mob/user, atom/target, list/modifiers)
	SIGNAL_HANDLER
	if(!camera_mode_active)
		return
	take_phone_picture(user, get_turf(target))

/obj/item/smartphone/proc/take_phone_picture(mob/user, turf/target)
	if(!user || !target)
		return FALSE
	if(!camera_mode_active)
		return FALSE
	var/obj/item/camera/phone/camera = ensure_phone_camera()
	return camera.attempt_picture(target, user)

/obj/item/smartphone/proc/store_gallery_photo(datum/picture/picture, mob/user)
	if(!picture)
		return
	var/datum/phone_gallery_photo/entry = new()
	entry.picture = picture
	entry.time_taken = server_timestamp("hh:mm", ic_time = TRUE)
	gallery_photos += entry
	while(length(gallery_photos) > PHONE_GALLERY_MAX_PHOTOS)
		var/datum/phone_gallery_photo/oldest = gallery_photos[1]
		gallery_photos.Cut(1, 2)
		qdel(oldest)
	if(user)
		balloon_alert(user, "Saved to gallery!")
	SStgui.update_uis(src)

/obj/item/smartphone/proc/format_phone_gallery_photos()
	var/list/formatted = list()
	for(var/i in 1 to length(gallery_photos))
		var/datum/phone_gallery_photo/entry = gallery_photos[i]
		var/datum/picture/picture = entry?.picture
		if(!picture?.picture_image)
			continue
		var/icon/thumbnail = picture.get_small_icon()
		UNTYPED_LIST_ADD(formatted, list(
			"id" = i,
			"name" = picture.picture_name,
			"time" = entry.time_taken,
			"thumbnail" = thumbnail ? icon2base64(thumbnail) : null,
		))
	return formatted

/obj/item/smartphone/proc/get_phone_camera_ui_data()
	var/list/data = list()
	data["camera_mode"] = camera_mode_active
	data["photos"] = format_phone_gallery_photos()
	if(viewing_photo?.picture?.picture_image)
		var/datum/picture/picture = viewing_photo.picture
		data["viewing_photo"] = list(
			"id" = gallery_photos.Find(viewing_photo),
			"name" = picture.picture_name,
			"desc" = picture.picture_desc,
			"time" = viewing_photo.time_taken,
			"image" = icon2base64(picture.picture_image),
		)
	else
		data["viewing_photo"] = null
	return data

/obj/item/smartphone/proc/handle_phone_camera_ui_act(action, list/params, datum/tgui/ui)
	switch(action)
		if("camera_open")
			start_camera_mode()
			return TRUE
		if("camera_close")
			stop_camera_mode()
			return TRUE
		if("take_photo")
			var/mob/living/user = ui?.user
			if(!isliving(user))
				return FALSE
			var/turf/target = get_turf(user.client?.eye || user)
			return take_phone_picture(user, target)
		if("view_photo")
			var/photo_id = text2num(params["id"])
			if(!photo_id || photo_id < 1 || photo_id > length(gallery_photos))
				return FALSE
			viewing_photo = gallery_photos[photo_id]
			return TRUE
		if("close_photo")
			viewing_photo = null
			return TRUE
	return FALSE