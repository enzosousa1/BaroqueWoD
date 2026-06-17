/obj/item/bodypart/head/anthro
	icon_greyscale = 'modular_nocturne/modules/customization/icons/mob/human/species/anthro/bodyparts.dmi'
	limb_id = SPECIES_ANTHRO

/obj/item/bodypart/chest/anthro
	icon_greyscale = 'modular_nocturne/modules/customization/icons/mob/human/species/anthro/bodyparts.dmi'
	limb_id = SPECIES_ANTHRO

/obj/item/bodypart/arm/left/anthro
	icon_greyscale = 'modular_nocturne/modules/customization/icons/mob/human/species/anthro/bodyparts.dmi'
	limb_id = SPECIES_ANTHRO

/obj/item/bodypart/arm/right/anthro
	icon_greyscale = 'modular_nocturne/modules/customization/icons/mob/human/species/anthro/bodyparts.dmi'
	limb_id = SPECIES_ANTHRO

/obj/item/bodypart/leg/left/anthro
	icon_greyscale = 'modular_nocturne/modules/customization/icons/mob/human/species/anthro/bodyparts.dmi'
	limb_id = SPECIES_ANTHRO

/obj/item/bodypart/leg/right/anthro
	icon_greyscale = 'modular_nocturne/modules/customization/icons/mob/human/species/anthro/bodyparts.dmi'
	limb_id = SPECIES_ANTHRO

/obj/item/bodypart/leg/left/digitigrade/anthro
	icon_greyscale = 'modular_nocturne/modules/customization/icons/mob/human/species/anthro/bodyparts.dmi'

/obj/item/bodypart/leg/left/digitigrade/anthro/Initialize(mapload)
	. = ..()
	qdel(GetComponent(/datum/component/digitigrade_limb))
	AddComponent(/datum/component/digitigrade_limb, SPECIES_ANTHRO, initial(limb_id))

/obj/item/bodypart/leg/right/digitigrade/anthro
	icon_greyscale = 'modular_nocturne/modules/customization/icons/mob/human/species/anthro/bodyparts.dmi'

/obj/item/bodypart/leg/right/digitigrade/anthro/Initialize(mapload)
	. = ..()
	qdel(GetComponent(/datum/component/digitigrade_limb))
	AddComponent(/datum/component/digitigrade_limb, SPECIES_ANTHRO, initial(limb_id))
