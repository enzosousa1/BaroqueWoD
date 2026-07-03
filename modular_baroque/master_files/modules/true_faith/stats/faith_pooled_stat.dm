/datum/st_stat/pooled/faith
	name = "Faith"
	description = "A character's unwavering belief and spiritual strength. Kindred and ghouls cannot possess this stat."
	freebie_point_cost = FREEBIE_COST_FAITH
	stat_flags = AFFECTS_STATS
	max_score = FAITH_MAX_SCORE
	/// Set by update_faith_stat_availability() when the character splat cannot possess True Faith.
	var/faith_restricted = FALSE

/datum/st_stat/pooled/faith/can_increase_score(amount)
	if(faith_restricted)
		return FALSE
	return ..()

/datum/st_stat/pooled/faith/can_decrease_score(amount)
	if(faith_restricted)
		return FALSE
	return ..()
