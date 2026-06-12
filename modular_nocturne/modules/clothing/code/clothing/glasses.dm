#define CLOTHING_GLASSES_ICONS \
	icon = 'modular_nocturne/modules/clothing/icons/clothing.dmi'; \
	worn_icon = 'modular_nocturne/modules/clothing/icons/worn.dmi'; \
	ONFLOOR_ICON_HELPER('modular_nocturne/modules/clothing/icons/onfloor.dmi')


// aviators

/obj/item/clothing/glasses/vampire/aviator
	name = "aviators"
	desc = "Thick framed aviators."
	icon_state = "aviator"
	inhand_icon_state = "glasses"
	CLOTHING_GLASSES_ICONS

/obj/item/clothing/glasses/vampire/aviator/green
	name = "green aviators"
	desc = "Thick-framed aviators, now in green."
	icon_state = "aviator_green"

/obj/item/clothing/glasses/vampire/aviator/blue
	name = "blue aviators"
	desc = "Thick-framed aviators, now in blue."
	icon_state = "aviator_blue"


// sunglasses

/obj/item/clothing/glasses/vampire/sun/oversized
	name = "oversized sunglasses"
	desc = "Oversized visor sunglasses. Extra cool at night."
	icon_state = "bigsunglasses"
	CLOTHING_GLASSES_ICONS

/obj/item/clothing/glasses/vampire/sun/thin
	name = "thin sunglasses"
	desc = "A pair of thin-framed sunglasses."
	icon_state = "sun_thin"
	CLOTHING_GLASSES_ICONS


// prescription glasses

/obj/item/clothing/glasses/vampire/perception/green
	name = "green prescription glasses"
	desc = "Prescription glasses with thick, green plastic frames."
	icon_state = "gglasses"
	CLOTHING_GLASSES_ICONS

/obj/item/clothing/glasses/vampire/perception/retro
	name = "retro glasses"
	desc = "Prescription glasses straight out of the 1980s."
	icon_state = "glasses"
	CLOTHING_GLASSES_ICONS

/obj/item/clothing/glasses/vampire/perception/metal
	name = "metal-framed prescription glasses"
	desc = "Prescribed glasses with a thick metal frame."
	icon_state = "hipster_glasses"
	CLOTHING_GLASSES_ICONS


// misc

/obj/item/clothing/glasses/vampire/bicolor
	name = "bicolor glasses"
	desc = "These let you see the whole world in 3D."
	icon_state = "3d"
	inhand_icon_state = "glasses"
	CLOTHING_GLASSES_ICONS

/obj/item/clothing/glasses/vampire/safety
	name = "safety goggles"
	desc = "Always wear personal protective equipment when sulking."
	icon_state = "degoggles"
	inhand_icon_state = "glasses"
	CLOTHING_GLASSES_ICONS


// eyepatches

/obj/item/clothing/glasses/vampire/eyepatch
	name = "right eyepatch"
	desc = "Black and menacing."
	icon_state = "eyepatch"
	CLOTHING_GLASSES_ICONS

/obj/item/clothing/glasses/vampire/eyepatch/left
	name = "left eyepatch"
	desc = "Black and menacing."
	icon_state = "eyepatch_1"

/obj/item/clothing/glasses/vampire/eyepatch/medical
	name = "right medical eyepatch"
	desc = "The less menacing option."
	icon_state = "eyepatch_white"

/obj/item/clothing/glasses/vampire/eyepatch/medical_left
	name = "left medical eyepatch"
	desc = "The less menacing option."
	icon_state = "eyepatch_white_1"

#undef CLOTHING_GLASSES_ICONS
