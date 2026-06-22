/obj/structure/fluff/retail
	name = "retail outlet"
	desc = "A counter for partaking in wretched capitalism. Takes cash or card."
	icon = 'modular_darkpack/modules/retail/icons/vendors_shops.dmi'
	icon_state = "register"


// graffiti

// hardcoded anarch grafitti

/obj/effect/decal/anarch_graffiti
	name = "graffiti"
	icon = 'modular_darkpack/modules/deprecated/icons/32x48.dmi'
	icon_state = "graffiti1"
	pixel_z = 32
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER

/obj/effect/decal/anarch_graffiti/NeverShouldHaveComeHere(turf/here_turf)
	return isclosedturf(here_turf)

// dumb shit to scribble onto the floor

/obj/effect/turf_decal/floor_graffiti
	name = "graffiti"
	icon = 'modular_nocturne/modules/decor/icons/graffiti.dmi'
	icon_state = "graffiti_floor1"
	base_icon_state = "graffiti_floor"
	var/variants = 2

/obj/effect/turf_decal/floor_graffiti/random/Initialize(mapload)
	. = ..()
	icon_state = "[base_icon_state][rand(1, variants)]"

// for the nightclub

/obj/effect/turf_decal/nightclub_graffiti
	name = "graffiti"
	icon = 'modular_nocturne/modules/decor/icons/graffiti_64x64.dmi'
	icon_state = "nightclub"
	pixel_x = -16
	pixel_y = -16
