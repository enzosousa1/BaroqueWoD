/datum/job/vampire/mayor
	title = JOB_MAYOR
	description = "The Mayor of Santa Augustina is the head of the city government, responsible for overseeing the administration of city services, implementing policies, and representing the interests of the citizens. The Mayor works closely with the city council and other officials to ensure the smooth operation of the city and to address the needs and concerns of its residents."
	faction = FACTION_TOWNHALL
	total_positions = 1
	spawn_positions = 1
	config_tag = "MAYOR"
	outfit = /datum/outfit/job/vampire/mayor
	job_flags = CITY_JOB_FLAGS
	exp_required_type_department = EXP_TYPE_SERVICES
	department_for_prefs = /datum/job_department/city_services
	departments_list = list(
		/datum/job_department/city_services,
	)
	display_order = JOB_DISPLAY_ORDER_MAYOR
	minimal_masquerade = 0

/obj/item/card/mayor
	name = "mayor card"
	desc = "A badge which shows that he is the Mayor."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "regent_id"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "regent_id"

/datum/outfit/job/vampire/mayor
	name = "Mayor"
	jobtype = /datum/job/vampire/mayor
	uses_default_clan_clothes = TRUE

	id = /obj/item/card/mayor
	suit = /obj/item/clothing/suit/toggle/lawyer/black
	l_pocket = /obj/item/smartphone
	r_pocket = /obj/item/vamp/keys/mayor
	backpack_contents = list(
		/obj/item/card/credit = 1,
		/obj/item/stack/dollar/thousand = 1,
	)
