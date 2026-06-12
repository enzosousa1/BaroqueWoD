#define CLOTHING_NECK_ICONS \
	icon = 'modular_nocturne/modules/clothing/icons/clothing.dmi'; \
	worn_icon = 'modular_nocturne/modules/clothing/icons/worn.dmi'; \
	ONFLOOR_ICON_HELPER('modular_nocturne/modules/clothing/icons/onfloor.dmi')

/obj/item/clothing/neck/vampire/choker
	name = "black choker"
	desc = "A plain black choker. Popular with goths!"
	icon_state = "blackchoker"
	CLOTHING_NECK_ICONS

/obj/item/clothing/neck/vampire/choker/metal
	name = "metallic choker"
	desc = "A silver, metallic choker. Scene chicks seem to dig it!"
	icon_state = "steelchoker"

/obj/item/clothing/neck/vampire/choker/leather
	name = "leather choker"
	desc = "A leather choker with a steel ring pendant."
	icon_state = "leathercollar"

/obj/item/clothing/neck/vampire/choker/silver
	name = "silver chain choker"
	desc = "A chain choker in tarnish-resistant, hypoallergenic silver. Hardcore."
	icon_state = "steelcollar"

/obj/item/clothing/neck/vampire/choker/fancy
	name = "fancy choker"
	desc = "A black choker with a gold ring pendant. A little classier than the alternatives."
	icon_state = "leathercollar_g"

#undef CLOTHING_NECK_ICONS
