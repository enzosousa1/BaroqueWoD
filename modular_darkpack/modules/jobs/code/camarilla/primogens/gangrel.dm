/datum/job/vampire/primogen_gangrel
	title = JOB_PRIMOGEN_GANGREL
	description = "Offer your infinite knowledge to Prince of the City, while overseeing the Gangrel in the city. Monitor their primal instincts and ensure they remain true to the ways of the Clan. You have an official cover with the local park services, ensure things run smoothly, on either end."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = FACTION_CAMARILLA
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_TRADITIONS
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CAMARILLA
	exp_required_type_department = EXP_TYPE_CAMARILLA
	exp_granted_type = EXP_TYPE_CAMARILLA
	config_tag = "PRIMOGEN_GANGREL"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/gangrelprim

	display_order = JOB_DISPLAY_ORDER_GANGREL
	department_for_prefs = /datum/job_department/camarilla
	departments_list = list(
		/datum/job_department/camarilla,
	)

	minimal_generation = 12
	minimum_immortal_age = 50
	minimal_masquerade = 5
	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_CITY_GANGREL)

	known_contacts = list("Prince")

/datum/outfit/job/vampire/gangrelprim
	name = "Primogen Gangrel"
	jobtype = /datum/job/vampire/primogen_gangrel

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/primogen
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/turtleneck_black
	suit = /obj/item/clothing/suit/vampire/jacket
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/smartphone/ventrue_primo
	backpack_contents = list(/obj/item/vamp/keys/ventrue/primogen=1, /obj/item/card/credit/elder=1, /obj/item/card/whip, /obj/item/card/steward, /obj/item/card/myrmidon)
