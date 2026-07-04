/obj/effect/mapping_helpers/door/access/mayor
	name = "mayor access"
	desc = "Sets the door lock ID to mayor access."
	lock_id = LOCKACCESS_MAYOR

/obj/effect/mapping_helpers/mayor_console
	name = "mayor console spawner"
	desc = "Spawns a mayor's console on this turf."
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = "landmark"

/obj/effect/mapping_helpers/mayor_console/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/mapping_helpers/mayor_console/LateInitialize()
	new /obj/structure/mayor_console(loc)
	qdel(src)