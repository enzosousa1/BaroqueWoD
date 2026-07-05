/// True Faith interactions for the hunter's cross.

/obj/item/card/hunter/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
	if(!ishuman(target_mob) || !isliving(user))
		return ..()

	var/mob/living/carbon/human/human_target = target_mob
	if(!channel_faith_interaction(human_target, user, at_range = FALSE))
		return TRUE

	return ..()

/obj/item/card/hunter/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ishuman(interacting_with) || !isliving(user))
		return NONE

	var/mob/living/carbon/human/human_target = interacting_with
	if(!channel_faith_interaction(human_target, user, at_range = TRUE))
		return NONE

	return ITEM_INTERACT_SUCCESS

/obj/item/card/hunter/proc/channel_faith_interaction(mob/living/carbon/human/target, mob/living/user, at_range = FALSE)
	if(at_range && get_dist(get_turf(user), get_turf(target)) > FAITH_CROSS_MAX_RANGE)
		to_chat(user, span_warning("They are too far away for your faith to reach."))
		return FALSE

	if(!COOLDOWN_FINISHED(src, detonation_timer))
		to_chat(user, span_warning("Your faith still needs a moment to gather strength."))
		return FALSE

	if(user.st_get_stat(STAT_FAITH) < 1)
		to_chat(user, span_warning("You lack the faith to invoke the cross."))
		return FALSE

	user.do_attack_animation(target)

	if(!do_after(user, FAITH_CROSS_CHANNEL_TIME, target, interaction_key = src))
		return FALSE

	apply_faith_to_human(target, user, at_range)
	add_fingerprint(user)
	return TRUE