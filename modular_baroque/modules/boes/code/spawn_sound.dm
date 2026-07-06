/datum/antagonist/ert/baroque
	abstract_type = /datum/antagonist/ert/baroque

/datum/antagonist/ert/baroque/boes
	random_names = FALSE

/datum/antagonist/ert/baroque/boes/on_gain()
	. = ..()
	apply_boes_faith()
	play_boes_spawn_sound()

/datum/antagonist/ert/baroque/boes/proc/apply_boes_faith(faith_level = BOES_FAITH_LEVEL)
	var/mob/living/spawnee = owner?.current
	if(!spawnee?.storyteller_stats?[STAT_FAITH])
		return
	spawnee.st_set_stat(STAT_FAITH, faith_level)

/datum/antagonist/ert/baroque/boes/proc/play_boes_spawn_sound()
	var/mob/living/spawnee = owner?.current
	if(!spawnee?.client)
		return
	SEND_SOUND(spawnee, sound(BOES_SPAWN_SOUND, volume = 50))