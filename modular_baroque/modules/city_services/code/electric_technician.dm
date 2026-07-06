/obj/item/storage/belt/utility/electric_technician
	name = "electric technician's toolbelt"
	desc = "Holds tools, looks snazzy."
	icon_state = "utility_ce"
	inhand_icon_state = "utility_ce"
	worn_icon_state = "utility_ce"

/obj/item/storage/belt/utility/electric_technician/full
	preload = TRUE

/obj/item/storage/belt/utility/electric_technician/full/PopulateContents()
	SSwardrobe.provide_type(/obj/item/screwdriver/power, src)
	SSwardrobe.provide_type(/obj/item/crowbar/hammer, src)
	SSwardrobe.provide_type(/obj/item/weldingtool, src)
	SSwardrobe.provide_type(/obj/item/multitool, src)
	SSwardrobe.provide_type(/obj/item/stack/cable_coil, src)
	SSwardrobe.provide_type(/obj/item/extinguisher/mini, src)

/obj/item/storage/belt/utility/electric_technician/full/get_types_to_preload()
	var/list/to_preload = list()
	to_preload += /obj/item/screwdriver/power
	to_preload += /obj/item/crowbar/hammer
	to_preload += /obj/item/weldingtool
	to_preload += /obj/item/multitool
	to_preload += /obj/item/stack/cable_coil
	to_preload += /obj/item/extinguisher/mini
	return to_preload

/datum/job/vampire/electric_technician
	title = JOB_ELECTRIC_TECHNICIAN
	description = "An electric technician for the city, responsible for maintaining and repairing electrical systems and equipment."
	faction = FACTION_CITY
	total_positions = 2
	spawn_positions = 2
	config_tag = "ELECTRIC_TECHNICIAN"
	outfit = /datum/outfit/job/vampire/electric_technician
	job_flags = CITY_JOB_FLAGS
	exp_required_type_department = EXP_TYPE_SERVICES
	department_for_prefs = /datum/job_department/city_services
	departments_list = list(
		/datum/job_department/city_services,
	)
	display_order = JOB_DISPLAY_ORDER_ELECTRIC_TECHNICIAN
	minimal_masquerade = 0

/obj/item/card/electric_technician
	name = "electric technician card"
	desc = "A badge which shows that he is an electric technician for the city."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "grey_id"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "grey_id"

/datum/outfit/job/vampire/electric_technician
	name = "Electric Technician"
	jobtype = /datum/job/vampire/electric_technician
	uses_default_clan_clothes = TRUE

	id = /obj/item/card/electric_technician
	uniform = /obj/item/clothing/under/rank/engineering/engineer
	belt = /obj/item/storage/belt/utility/electric_technician/full
	gloves = /obj/item/clothing/gloves/color/yellow
	head = /obj/item/clothing/head/collectable/hardhat
	shoes = /obj/item/clothing/shoes/workboots
	l_pocket = /obj/item/smartphone
	backpack_contents = list(
		/obj/item/card/credit = 1,
		/obj/item/storage/box/lights/mixed = 1,
		/obj/item/lightreplacer = 1,
	)
