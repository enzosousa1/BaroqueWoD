#define CLOTHING_SUIT_ICONS \
	icon = 'modular_nocturne/modules/clothing/icons/clothing.dmi'; \
	worn_icon = 'modular_nocturne/modules/clothing/icons/worn.dmi'; \
	ONFLOOR_ICON_HELPER('modular_nocturne/modules/clothing/icons/onfloor.dmi')

/obj/item/clothing/suit/vampire
	abstract_type = /obj/item/clothing/suit/vampire


// parkas

/obj/item/clothing/suit/hooded/hoodie/parka
	name = "parka"
	desc = "A heavy fur-lined winter coat, for all the snow in California."
	icon_state = "greenpark"
	hoodtype = /obj/item/clothing/head/hooded/hood_hood/parka
	CLOTHING_SUIT_ICONS

/obj/item/clothing/head/hooded/hood_hood/parka
	name = "parka hood"
	desc = "A heavy fur-lined hood, for all the snow in California."
	icon_state = "greenpark_hood"
	icon = 'modular_nocturne/modules/clothing/icons/clothing.dmi'
	worn_icon = 'modular_nocturne/modules/clothing/icons/worn.dmi'

/obj/item/clothing/suit/hooded/hoodie/parka/yellow
	name = "yellow parka"
	icon_state = "yellowpark"
	hoodtype = /obj/item/clothing/head/hooded/hood_hood/parka/yellow

/obj/item/clothing/head/hooded/hood_hood/parka/yellow
	name = "yellow parka hood"
	icon_state = "yellowpark_hood"

/obj/item/clothing/suit/hooded/hoodie/parka/red
	name = "red parka"
	icon_state = "redpark"
	hoodtype = /obj/item/clothing/head/hooded/hood_hood/parka/red

/obj/item/clothing/head/hooded/hood_hood/parka/red
	name = "red parka hood"
	icon_state = "redpark_hood"

/obj/item/clothing/suit/hooded/hoodie/parka/purple
	name = "purple parka"
	icon_state = "purplepark"
	hoodtype = /obj/item/clothing/head/hooded/hood_hood/parka/purple

/obj/item/clothing/head/hooded/hood_hood/parka/purple
	name = "purple parka hood"
	icon_state = "purplepark_hood"

/obj/item/clothing/suit/hooded/hoodie/parka/blue
	name = "blue parka"
	icon_state = "bluepark"
	hoodtype = /obj/item/clothing/head/hooded/hood_hood/parka/blue

/obj/item/clothing/head/hooded/hood_hood/parka/blue
	name = "blue parka hood"
	icon_state = "bluepark_hood"

/obj/item/clothing/suit/hooded/hoodie/parka_vintage
	name = "vintage parka"
	desc = "A heavy fur-lined winter coat, for all the snow in California."
	icon_state = "vintagepark"
	hoodtype = /obj/item/clothing/head/hooded/hood_hood/parka_vintage
	CLOTHING_SUIT_ICONS

/obj/item/clothing/head/hooded/hood_hood/parka_vintage
	name = "vintage parka hood"
	desc = "A heavy fur-lined hood, for all the snow in California."
	icon_state = "vintagepark_hood"
	icon = 'modular_nocturne/modules/clothing/icons/clothing.dmi'
	worn_icon = 'modular_nocturne/modules/clothing/icons/worn.dmi'


// letterman jackets

/obj/item/clothing/suit/vampire/letterman
	name = "letterman jacket"
	desc = "A classic letterman jacket."
	icon_state = "letterman_c"
	CLOTHING_SUIT_ICONS


// military jackets

/obj/item/clothing/suit/vampire/militaryjacket
	abstract_type = /obj/item/clothing/suit/vampire/militaryjacket
	CLOTHING_SUIT_ICONS

/obj/item/clothing/suit/vampire/militaryjacket/white
	name = "white military jacket"
	desc = "A white military-style jacket."
	icon_state = "militaryjacket_white"

/obj/item/clothing/suit/vampire/militaryjacket/tan
	name = "tan military jacket"
	desc = "A tan military-style jacket."
	icon_state = "militaryjacket_tan"

/obj/item/clothing/suit/vampire/militaryjacket/navy
	name = "navy military jacket"
	desc = "A navy military-style jacket."
	icon_state = "militaryjacket_navy"

/obj/item/clothing/suit/vampire/militaryjacket/grey
	name = "grey military jacket"
	desc = "A grey military-style jacket."
	icon_state = "militaryjacket_grey"

/obj/item/clothing/suit/vampire/militaryjacket/black
	name = "black military jacket"
	desc = "A black military-style jacket."
	icon_state = "militaryjacket_black"


// leather jackets

/obj/item/clothing/suit/vampire/jacket3
	name = "stylish jacket"
	desc = "A stylish jacket."
	icon_state = "jacket3"
	CLOTHING_SUIT_ICONS

/obj/item/clothing/suit/vampire/jacket1_cut
	name = "cut black leather jacket"
	desc = "A black leather jacket."
	icon_state = "jacket1_cut"
	CLOTHING_SUIT_ICONS

/obj/item/clothing/suit/vampire/jacket2_cut
	name = "cut brown leather jacket"
	desc = "A brown leather jacket."
	icon_state = "jacket2_cut"
	CLOTHING_SUIT_ICONS

/obj/item/clothing/suit/vampire/jacket3_cut
	name = "cut stylish jacket"
	desc = "A stylish jacket."
	icon_state = "jacket3_cut"
	CLOTHING_SUIT_ICONS


// bomber jackets

/obj/item/clothing/suit/vampire/bomber
	name = "bomber jacket"
	desc = "A bomber jacket."
	icon_state = "bomber"
	CLOTHING_SUIT_ICONS

/obj/item/clothing/suit/vampire/bomber/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/suit/vampire/bomber/retro
	name = "retro bomber jacket"
	desc = "A retro-style bomber jacket."
	icon_state = "retro_bomber"

/obj/item/clothing/suit/vampire/bomber/retro/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)


// varsity jackets

/obj/item/clothing/suit/vampire/varsity
	name = "varsity jacket"
	desc = "A varsity jacket."
	icon_state = "varsity"
	CLOTHING_SUIT_ICONS

/obj/item/clothing/suit/vampire/varsity/purple
	name = "purple varsity jacket"
	desc = "A purple varsity jacket."
	icon_state = "varsity_purple"


// flannels

/obj/item/clothing/suit/vampire/flannel
	name = "black flannel"
	desc = "A comfy, black flannel shirt. Unleash your inner hipster."
	icon_state = "flannel"
	CLOTHING_SUIT_ICONS

/obj/item/clothing/suit/vampire/flannel/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/suit/vampire/flannel/red
	name = "red flannel"
	desc = "A comfy, red flannel shirt. Unleash your inner hipster."
	icon_state = "flannel_red"

/obj/item/clothing/suit/vampire/flannel/aqua
	name = "aqua flannel"
	desc = "A comfy, aqua flannel shirt. Unleash your inner hipster."
	icon_state = "flannel_aqua"

/obj/item/clothing/suit/vampire/flannel/brown
	name = "brown flannel"
	desc = "A comfy, brown flannel shirt. Unleash your inner hipster."
	icon_state = "flannel_brown"

// short sleeved flannels

/obj/item/clothing/suit/vampire/flannel/short
	name = "short-sleeved flannel"
	desc = "A comfy, red flannel shirt. Unleash your inner hipster."
	icon_state = "flannel_short"

/obj/item/clothing/suit/vampire/flannel/short/red
	name = "red short-sleeved flannel"
	desc = "A comfy, red flannel shirt. Unleash your inner hipster."
	icon_state = "flannel_red_short"

/obj/item/clothing/suit/vampire/flannel/short/aqua
	name = "aqua short-sleeved flannel"
	desc = "A comfy, aqua flannel shirt. Unleash your inner hipster."
	icon_state = "flannel_aqua_short"

/obj/item/clothing/suit/vampire/flannel/short/brown
	name = "brown short-sleeved flannel"
	desc = "A comfy, brown flannel shirt. Unleash your inner hipster."
	icon_state = "flannel_brown_short"

#undef CLOTHING_SUIT_ICONS
