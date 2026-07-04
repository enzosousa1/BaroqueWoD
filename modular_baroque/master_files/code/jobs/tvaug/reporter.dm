/datum/job_department/tvaug
	department_name = DEPARTMENT_TV_AUGUSTA
	department_bitflags = DEPARTMENT_BITFLAG_TV_AUGUSTA

/datum/job/vampire/reporter
	title = JOB_TVAUG_REPORTER
	description = "A reporter for TV Augustina, investigating stories and interviewing sources."
	faction = FACTION_TVAUG
	total_positions = 2
	spawn_positions = 2
	config_tag = "REPORTER"
	outfit = /datum/outfit/job/vampire/reporter
	job_flags = CITY_JOB_FLAGS
	exp_required_type_department = EXP_TYPE_SERVICES
	department_for_prefs = /datum/job_department/tvaug
	departments_list = list(
		/datum/job_department/tvaug,
	)
	display_order = JOB_DISPLAY_ORDER_TVAUG_REPORTER
	minimal_masquerade = 0

/obj/item/card/reporter
	name = "reporter card"
	desc = "A badge which shows that he is a reporter for TV Augustina."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "grey_id"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "grey_id"

/datum/outfit/job/vampire/reporter
	name = "Reporter"
	jobtype = /datum/job/vampire/reporter
	uses_default_clan_clothes = TRUE

	id = /obj/item/card/reporter
	suit = /obj/item/clothing/suit/toggle/lawyer/black
	l_pocket = /obj/item/smartphone
	backpack_contents = list(
		/obj/item/card/credit = 1,
		/obj/item/radio/entertainment/microphone/physical = 1,
	)
