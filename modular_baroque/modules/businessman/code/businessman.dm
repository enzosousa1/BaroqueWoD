/datum/job/vampire/businessman
	title = JOB_BUSINESSMAN
	description = "A businessman, an entrepreneur...someone who knows that money has no smell."
	faction = FACTION_CITY
	total_positions = 3
	spawn_positions = 3
	config_tag = "BUSINESSMAN"
	outfit = /datum/outfit/job/vampire/businessman
	job_flags = CITY_JOB_FLAGS
	exp_required_type_department = EXP_TYPE_SERVICES
	department_for_prefs = /datum/job_department/city_services
	departments_list = list(
		/datum/job_department/city_services,
	)
	display_order = JOB_DISPLAY_ORDER_BUSINESSMAN
	minimal_masquerade = 0

/obj/item/card/businessman
	name = "businessman card"
	desc = "A badge which shows that he is owner of a business."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "grey_id"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "grey_id"

/datum/outfit/job/vampire/businessman
	name = "Businessman"
	jobtype = /datum/job/vampire/businessman
	uses_default_clan_clothes = TRUE

	id = /obj/item/card/businessman
	suit = /obj/item/clothing/suit/toggle/lawyer/black
	l_pocket = /obj/item/smartphone
	backpack_contents = list(
		/obj/item/card/credit = 1,
		/obj/item/stack/dollar/thousand = 1,
	)
