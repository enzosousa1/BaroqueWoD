/datum/antagonist/ert/baroque
	abstract_type = /datum/antagonist/ert/baroque

/datum/antagonist/ert/baroque/boes

/datum/antagonist/ert/baroque/boes/on_gain()
	. = ..()
	play_boes_spawn_sound()

/datum/antagonist/ert/baroque/boes/proc/play_boes_spawn_sound()
	var/mob/living/spawnee = owner?.current
	if(!spawnee?.client)
		return
	SEND_SOUND(spawnee, sound(BOES_SPAWN_SOUND, volume = 50))