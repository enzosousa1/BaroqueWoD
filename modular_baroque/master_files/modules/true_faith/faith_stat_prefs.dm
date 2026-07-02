/// Runs before the stats middleware builds UI data so new stats appear without resetting saves.
/datum/preference_middleware/baroque_faith_stats

/datum/preference_middleware/baroque_faith_stats/get_ui_data(mob/user)
	if(preferences.current_window != PREFERENCE_TAB_CHARACTER_PREFERENCES)
		return list()
	merge_missing_stat_prefs(preferences.preference_storyteller_stats)
	return list()