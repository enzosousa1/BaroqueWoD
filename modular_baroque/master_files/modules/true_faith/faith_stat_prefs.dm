/// Runs before the stats middleware builds UI data so new stats appear without resetting saves.
/datum/preference_middleware/baroque_faith_stats

/datum/preference_middleware/baroque_faith_stats/get_ui_data(mob/user)
	if(preferences.current_window != PREFERENCE_TAB_CHARACTER_PREFERENCES)
		return list()
	merge_missing_stat_prefs(preferences.preference_storyteller_stats)
	update_faith_stat_availability(preferences)
	update_middleware_stats(preferences.preference_storyteller_stats)
	return list()

/datum/preference_middleware/baroque_faith_stats/post_set_preference(mob/user, preference, value)
	if(preference != /datum/preference/choiced/splats)
		return
	if(is_faith_restricted_splat(value))
		to_chat(user, span_warning("The undead cannot possess True Faith."))
	update_faith_stat_availability(preferences)
	update_middleware_stats(preferences.preference_storyteller_stats)

/datum/preference_middleware/baroque_faith_stats/apply_to_human(mob/living/carbon/human/target, datum/preferences/preferences)
	if(get_kindred_splat(target) || get_ghoul_splat(target))
		target.strip_faith_from_mob()