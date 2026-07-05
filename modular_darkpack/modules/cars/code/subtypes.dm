/obj/darkpack_car/retro
	icon_state = "1"
	max_passengers = 1
	dir = WEST

/obj/darkpack_car/retro/unlocked
	locked = FALSE

// So insanely useful for testing im leaving it uncommented
/obj/darkpack_car/retro/debug
	debug_car = TRUE
	locked = FALSE

/obj/darkpack_car/retro/rand
	icon_state = "3"

/obj/darkpack_car/retro/rand/Initialize(mapload)
	icon_state = "[pick(1, 3, 5)]"
	. = ..()

/obj/darkpack_car/rand
	icon_state = "4"
	dir = WEST

/obj/darkpack_car/rand/Initialize(mapload)
	icon_state = "[pick(2, 4, 6)]"
	. = ..()

/obj/darkpack_car/rand/camarilla
	access = LOCKACCESS_CAMARILLA

/obj/darkpack_car/retro/rand/camarilla
	access = LOCKACCESS_CAMARILLA

/obj/darkpack_car/retro/rand/voivodate
	access = "voivodate_citizen"

/obj/darkpack_car/rand/anarch
	access = LOCKACCESS_ANARCH

/obj/darkpack_car/retro/rand/anarch
	access = LOCKACCESS_ANARCH

/obj/darkpack_car/rand/clinic
	access = LOCKACCESS_CLINIC

/obj/darkpack_car/retro/rand/clinic
	access = LOCKACCESS_CLINIC

/obj/darkpack_car/limousine
	icon_state = "limo"
	max_passengers = 6
	dir = WEST
	car_storage_type = /datum/storage/car/limo

/obj/darkpack_car/limousine/giovanni
	icon_state = "giolimo"
	access = LOCKACCESS_GIOVANNI

/obj/darkpack_car/limousine/camarilla
	access = LOCKACCESS_CAMARILLA

/obj/darkpack_car/limousine/voivodate
	access = "seer_voivodate"

/obj/darkpack_car/police
	icon_state = "police"
	max_passengers = 3
	dir = WEST
	beep_sound = 'modular_darkpack/modules/cars/sounds/beep.ogg'
	access = LOCKACCESS_POLICE
	light_system = OVERLAY_LIGHT
	light_range = 6
	light_power = 6
	var/primary_light_color = "#ff0000"
	var/secondary_light_color = "#0000ff"
	var/next_color_primary = FALSE
	var/datum/looping_sound/car_audio/car_siren/siren_sound_loop
	var/siren_on = FALSE
	COOLDOWN_DECLARE(last_color_change)

/obj/darkpack_car/police/Initialize(mapload)
	. = ..()
	siren_sound_loop = new(src)
	set_light_color(primary_light_color)
	if(!secondary_light_color)
		secondary_light_color = primary_light_color

/obj/darkpack_car/police/Destroy()
	QDEL_NULL(siren_sound_loop)
	return ..()

/obj/darkpack_car/police/grant_driver_actions(mob/living/user)
	..()
	if(!istype(src, /obj/darkpack_car/police/unmarked))
		var/datum/action/darkpack_car/siren/siren_action = new()
		siren_action.Grant(user)

/obj/darkpack_car/police/proc/toggle_siren()
	if(istype(src, /obj/darkpack_car/police/unmarked))
		return
	set_siren_on(!siren_on)

/obj/darkpack_car/police/proc/set_siren_on(new_value)
	if(istype(src, /obj/darkpack_car/police/unmarked))
		return
	if(siren_on == new_value)
		return
	siren_on = new_value
	update_police_siren()

/obj/darkpack_car/police/proc/update_police_siren()
	if(!siren_sound_loop || istype(src, /obj/darkpack_car/police/unmarked))
		return
	if(siren_on)
		siren_sound_loop.start()
	else
		siren_sound_loop.stop()

/obj/darkpack_car/police/atom_break(damage_flag)
	set_siren_on(FALSE)
	return ..()

/obj/darkpack_car/police/ranger
	icon_state = "ranger"
	access = LOCKACCESS_PARK_RANGER
	primary_light_color = "#ffa500"
	secondary_light_color = "#ff8c00"

/obj/darkpack_car/police/unmarked
	icon_state = "unmarked"

/obj/darkpack_car/police/process(seconds_per_tick)
	// If the light is not on, OR if we only have 1 light color, there is 0 reason to swap between light states
	if(!light_on || (primary_light_color == secondary_light_color))
		return ..()
	if(!COOLDOWN_FINISHED(src, last_color_change))
		return ..()
	COOLDOWN_START(src, last_color_change, 1 SECONDS)
	if(next_color_primary)
		set_light_color(primary_light_color)
	else
		set_light_color(secondary_light_color)
	next_color_primary = !next_color_primary
	return ..()

/obj/darkpack_car/taxi
	icon_state = "taxi"
	max_passengers = 3
	dir = WEST
	access = LOCKACCESS_TAXI

/obj/darkpack_car/track
	icon_state = "track"
	max_passengers = 6
	dir = WEST
	access = "none"
	car_storage_type = /datum/storage/car/truck

/obj/darkpack_car/track/Initialize(mapload)
	. = ..()

/obj/darkpack_car/track/volkswagen
	icon_state = "volkswagen"
	car_storage_type = /datum/storage/car/van

/obj/darkpack_car/track/ambulance
	icon_state = "ambulance"
	access = LOCKACCESS_CLINIC
	car_storage_type = /datum/storage/car/van

/obj/darkpack_car/endroncar
	icon_state = "endron"
	max_passengers = 4
	access = LOCKACCESS_PENTEX

/obj/darkpack_car/endrontruck
	icon_state = "endrontruck"
	max_passengers = 6
	access = LOCKACCESS_PENTEX
	car_storage_type = /datum/storage/car/truck
