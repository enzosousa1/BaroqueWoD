/datum/job/vampire/cameraman
	title = JOB_TVAUG_CAMERA
	description = "A cameraman for TV Augustina, capturing footage and managing equipment."
	faction = FACTION_TVAUG
	total_positions = 2
	spawn_positions = 2
	config_tag = "CAMERAMAN"
	outfit = /datum/outfit/job/vampire/cameraman
	job_flags = CITY_JOB_FLAGS
	exp_required_type_department = EXP_TYPE_SERVICES
	department_for_prefs = /datum/job_department/tvaug
	departments_list = list(
		/datum/job_department/tvaug,
	)
	display_order = JOB_DISPLAY_ORDER_TVAUG_CAMERA
	minimal_masquerade = 0

/obj/item/card/cameraman
	name = "cameraman card"
	desc = "A badge which shows that he is a cameraman for TV Augustina."
	icon = 'modular_darkpack/modules/jobs/icons/id_items.dmi'
	icon_state = "grey_id"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/jobs/icons/id_onfloors.dmi')
	worn_icon = 'modular_darkpack/modules/jobs/icons/id_worn.dmi'
	worn_icon_state = "grey_id"

/datum/outfit/job/vampire/cameraman
	name = "Cameraman"
	jobtype = /datum/job/vampire/cameraman
	uses_default_clan_clothes = TRUE

	id = /obj/item/card/reporter
	suit = /obj/item/clothing/suit/toggle/lawyer/black
	l_pocket = /obj/item/smartphone
	backpack_contents = list(
		/obj/item/card/credit = 1,
		/obj/item/broadcast_camera/film_studio = 1,
	)
