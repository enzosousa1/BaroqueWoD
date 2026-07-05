/// Ensures newly added storyteller stats (such as Faith) exist on saved characters.

/proc/merge_missing_stat_prefs(list/preference_storyteller_stats)
	var/updated = FALSE
	for(var/stat_path in subtypesof(/datum/st_stat))
		if(stat_path in preference_storyteller_stats)
			continue
		var/datum/st_stat/stat = new stat_path()
		stat.set_score(stat.starting_score)
		preference_storyteller_stats[stat_path] = stat
		updated = TRUE
	return updated