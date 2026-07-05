/datum/client_colour/glass_colour/nvg_green
	priority = CLIENT_COLOR_GLASSES_PRIORITY
	color = list(
		0, 1, 0, 0,
		0, 1, 0, 0,
		0, 1, 0, 0,
		0, 0, 0, 1,
		0, 0.1, 0, 0
	)


/atom/movable/screen/fullscreen/nvg_overlay
	name = "Night Vision Effect"
	icon = 'modular_baroque/modules/nvgrain/icons/screen_full.dmi'
	icon_state = "nv"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = FULLSCREEN_LAYER
	plane = FULLSCREEN_PLANE
	blend_mode = BLEND_ADD
	alpha = 255

/atom/movable/screen/fullscreen/nvg_overlay/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	transform = matrix().Scale(1.5, 1.5)

/atom/movable/screen/fullscreen/nvg_overlay/grain
	icon_state = "grain"
	layer = FULLSCREEN_LAYER + 1
	alpha = 255

/obj/item/clothing/glasses/night
	var/nvg_active = FALSE
	var/static/nvg_color_source = "nvg_glasses"
	var/atom/movable/screen/fullscreen/nvg_overlay/lens_overlay
	var/atom/movable/screen/fullscreen/nvg_overlay/grain/grain_overlay

/obj/item/clothing/glasses/night/Initialize(mapload)
	. = ..()
	lens_overlay = new /atom/movable/screen/fullscreen/nvg_overlay()
	grain_overlay = new /atom/movable/screen/fullscreen/nvg_overlay/grain()

/obj/item/clothing/glasses/night/Destroy()
	QDEL_NULL(lens_overlay)
	QDEL_NULL(grain_overlay)
	return ..()

/obj/item/clothing/glasses/night/equipped(mob/living/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_EYES)
		update_nvg_visuals(user)

/obj/item/clothing/glasses/night/dropped(mob/living/user)
	. = ..()
	remove_all_visuals(user)

/obj/item/clothing/glasses/night/proc/update_nvg_visuals(mob/living/user)
	if(!user?.client)
		return

	user.client.screen |= lens_overlay

	if(nvg_active)
		user.add_client_colour(/datum/client_colour/glass_colour/nvg_green, nvg_color_source)
		user.client.screen |= grain_overlay
	else
		user.remove_client_colour(nvg_color_source)
		user.client.screen -= grain_overlay

/obj/item/clothing/glasses/night/proc/remove_all_visuals(mob/living/user)
	if(!user?.client)
		return
	user.remove_client_colour(nvg_color_source)
	user.client.screen -= lens_overlay
	user.client.screen -= grain_overlay

/datum/action/item_action/toggle_nv/do_effect(trigger_flags)
	if(!istype(target, /obj/item/clothing/glasses/night))
		return ..()

	var/obj/item/clothing/glasses/night/goggles = target
	var/mob/living/holder = goggles.loc

	goggles.nvg_active = !goggles.nvg_active

	if(goggles.nvg_active)
		goggles.color_cutoffs = list(5, 5, 5)
		goggles.flash_protect = FLASH_PROTECTION_SENSITIVE
		playsound(goggles, 'sound/items/night_vision_on.ogg', 30, TRUE, -3)
	else
		goggles.color_cutoffs = null
		goggles.flash_protect = FLASH_PROTECTION_NONE
		playsound(goggles, 'sound/machines/click.ogg', 30, TRUE, -3)

	if(istype(holder) && holder.get_slot_by_item(goggles) == ITEM_SLOT_EYES)
		goggles.update_nvg_visuals(holder)
		holder.update_sight()

	goggles.update_appearance()
	return TRUE
