/// Returns TRUE if the given splat path cannot possess True Faith.
/proc/is_faith_restricted_splat(splat_path)
	if(!ispath(splat_path))
		return FALSE
	return ispath(splat_path, /datum/splat/vampire/kindred) || ispath(splat_path, /datum/splat/vampire/ghoul)

/// Refunds spent points and zeroes faith on a character preferences slot.
/proc/strip_faith_from_prefs(datum/preferences/prefs)
	if(!prefs)
		return
	var/datum/st_stat/pooled/faith/faith_stat = prefs.preference_storyteller_stats?[STAT_FAITH]
	if(!faith_stat)
		return

	var/datum/st_stat/abstract_stat = prefs.preference_storyteller_stats[faith_stat.abstract_type]
	var/datum/st_stat/freebie_point_stat = prefs.preference_storyteller_stats[STAT_FREEBIE_POINTS]

	while(faith_stat.get_score(include_bonus = FALSE) > faith_stat.starting_score)
		if(freebie_point_stat?.can_increase_freebie_points(faith_stat.freebie_point_cost))
			freebie_point_stat.increase_freebie_points(faith_stat.freebie_point_cost)
		else if(abstract_stat)
			abstract_stat.increase_points(1)
		faith_stat.decrease_score(1)

	faith_stat.set_score(faith_stat.starting_score)

/// Updates whether faith can be edited based on the character's splat.
/proc/update_faith_stat_availability(datum/preferences/prefs)
	if(!prefs)
		return
	var/datum/st_stat/pooled/faith/faith_stat = prefs.preference_storyteller_stats?[STAT_FAITH]
	if(!faith_stat)
		return

	var/restricted = is_faith_restricted_splat(prefs.read_preference(/datum/preference/choiced/splats))
	if(restricted)
		strip_faith_from_prefs(prefs)
		faith_stat.editable = FALSE
		faith_stat.max_score = faith_stat.starting_score
	else
		faith_stat.editable = TRUE
		faith_stat.max_score = FAITH_MAX_SCORE

/// Zeroes faith on a spawned mob. Used when a character becomes kindred or ghoul.
/mob/living/proc/strip_faith_from_mob()
	var/datum/st_stat/pooled/faith/faith_stat = storyteller_stats?[STAT_FAITH]
	if(!faith_stat)
		return
	faith_stat.set_score(faith_stat.starting_score)

/datum/splat/vampire/kindred/on_gain()
	. = ..()
	owner.strip_faith_from_mob()

/datum/splat/vampire/ghoul/on_gain()
	. = ..()
	owner.strip_faith_from_mob()